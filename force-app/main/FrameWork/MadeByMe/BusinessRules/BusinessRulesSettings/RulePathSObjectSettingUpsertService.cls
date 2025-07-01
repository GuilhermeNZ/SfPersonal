/*
 * @description: Service class for RulePathSObjectSetting__c SObject Upsert Operations
 * @author Guilherme Zwipp
**/
public with sharing class RulePathSObjectSettingUpsertService {

    private RulePathSObjectSettingRepository repository;
    private BusinessRulesSettingValidator validator;

    private BR_RulePathFieldSettingRepository rulePathFieldSettingRepositoryInstance;

    public RulePathSObjectSettingUpsertService(){
        this.repository = RulePathSObjectSettingRepository.getInstance();
        this.validator = BusinessRulesSettingValidator.getInstance();

        this.rulePathFieldSettingRepositoryInstance = BR_RulePathFieldSettingRepository.getInstance();
    }

    private static final String RULE_KEY_DELIMITER = ';';
    private static final String FIELD_SETTING_COMPOSITE_SEPARATOR = '-';
    
    public Map<String,List<SObject>> byBusinessRulesSettingsRuleKey( List<BusinessRulesSetting__c> newBusinessRulesSettings, Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById ) {

        List<String> objectNames = Lists.byField( newBusinessRulesSettings, 'Object__c' );

        Map<String, RulePathSObjectSetting__c> rulePathSObjectSettingByObjectName = (Map<String, RulePathSObjectSetting__c>) Maps.indexBy(
            'ObjectAPIName__c'
            , this.repository.findByObjectAPINames( objectNames )
            , Map<String, RulePathSObjectSetting__c>.class
        );

        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByObjectNameAndFieldName = (Map<String,RulePathFieldSetting__c>) Maps.indexByCompositeKey(
            new List<String>{ 'Name', 'ObjectAPIName__c' }
            , this.rulePathFieldSettingRepositoryInstance.findByObjectNames( objectNames )
            , FIELD_SETTING_COMPOSITE_SEPARATOR
            , Map<String,RulePathFieldSetting__c>.class
        );

        Map<String,Schema.DescribeSobjectResult> describeSObjectByName = SObjectHelper.getDescribreSObjectByName( objectNames );

        Map<String,List<SObject>> result = this.getSObjectSettingsAndFieldSettingsToUpsert(
            newBusinessRulesSettings
            , oldBusinessRulesSettingById
            , rulePathSObjectSettingByObjectName
            , rulePathFieldSettingByObjectNameAndFieldName
            , describeSObjectByName
        );

        this.repository.save( result.get( 'RulePathSObjectSetting__c' ) );
        this.rulePathFieldSettingRepositoryInstance.save( result.get( 'RulePathFieldSetting__c' ) );

        return result;
    }

    private Map<String,List<SObject>> getSObjectSettingsAndFieldSettingsToUpsert(
        List<BusinessRulesSetting__c> newBusinessRulesSettings
        , Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById
        , Map<String, RulePathSObjectSetting__c> rulePathSObjectSettingByObjectName
        , Map<String,RulePathFieldSetting__c> rulePathFieldSettingByObjectNameAndFieldName
        , Map<String,Schema.DescribeSobjectResult> describeSObjectByName
    ) {
        for( BusinessRulesSetting__c newBusinessRulesSetting : newBusinessRulesSettings ) {
            if( String.isBlank( newBusinessRulesSetting.RuleKey__c ) ) continue;

            String ruleKeyDifference = this.getRuleKeyFieldsDifference( newBusinessRulesSetting, oldBusinessRulesSettingById );
            if( String.isBlank( ruleKeyDifference ) ) continue;

            List<String> fieldsToAddInQuery = this.extractFieldsFromRuleKeyDifference( ruleKeyDifference );

            this.validator.ruleKeyFieldsIsValid( fieldsToAddInQuery, describeSObjectByName, newBusinessRulesSetting );
            if( newBusinessRulesSetting.hasErrors() ) continue;

            RulePathSObjectSetting__c rulePathSObjectSetting = this.getOrCreateRulePathSetting( rulePathSObjectSettingByObjectName, newBusinessRulesSetting );

            rulePathFieldSettingByObjectNameAndFieldName = this.mergeQueryFields( rulePathFieldSettingByObjectNameAndFieldName, fieldsToAddInQuery, rulePathSObjectSetting.ObjectAPIName__c );

            if( String.isBlank( rulePathSObjectSetting.Id ) ) {
                rulePathSObjectSettingByObjectName.put( rulePathSObjectSetting.ObjectAPIName__c, rulePathSObjectSetting );
            }
        }

        return new Map<String,List<SObject>>{
            'RulePathSObjectSetting__c' => rulePathSObjectSettingByObjectName.values()
            , 'RulePathFieldSetting__c' => rulePathFieldSettingByObjectNameAndFieldName.values()
        };
    }

    private String getRuleKeyFieldsDifference( BusinessRulesSetting__c newBusinessRulesSetting, Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById ) {
        String ruleKeyDifference = newBusinessRulesSetting.RuleKey__c;

        if( oldBusinessRulesSettingById != null && oldBusinessRulesSettingById.containsKey( newBusinessRulesSetting.Id ) ) {
            BusinessRulesSetting__c oldBusinessRulesSetting = oldBusinessRulesSettingById.get( newBusinessRulesSetting.Id );
            if( !String.isBlank( oldBusinessRulesSetting.RuleKey__c ) ) ruleKeyDifference = oldBusinessRulesSetting.RuleKey__c.difference( ruleKeyDifference );
        }

        return ruleKeyDifference;
    }

    private RulePathSObjectSetting__c getOrCreateRulePathSetting( Map<String, RulePathSObjectSetting__c> rulePathSObjectSettingByObjectName, BusinessRulesSetting__c newBusinessRulesSetting ) {
        if( rulePathSObjectSettingByObjectName.containsKey( newBusinessRulesSetting.Object__c ) ) {
            return rulePathSObjectSettingByObjectName.get( newBusinessRulesSetting.Object__c );
        }

        return new BR_RulePathSObjectSettingBuilder()
            .withObjectAPIName( newBusinessRulesSetting.Object__c )
            .build();
    }

    private List<String> extractFieldsFromRuleKeyDifference( String ruleKeyStringDifference ) {

        List<String> fieldsToAddInQuery = new List<String>();

        for( String fieldAndValue : ruleKeyStringDifference.split( RULE_KEY_DELIMITER ) ) {
            if( String.isBlank( fieldAndValue ) ) continue;
            fieldsToAddInQuery.add( fieldAndValue.split( '=' )[0].replace( ' ', '' ) );
        }

        return fieldsToAddInQuery;
    }

    private Map<String,RulePathFieldSetting__c> mergeQueryFields( Map<String,RulePathFieldSetting__c> rulePathFieldSettingByObjectNameAndFieldName, List<String> fieldsToAddInQuery, String objectApiName ) {

        for( String fieldToAddInQuery : fieldsToAddInQuery ) {
            if( rulePathFieldSettingByObjectNameAndFieldName.containsKey( fieldToAddInQuery + FIELD_SETTING_COMPOSITE_SEPARATOR + objectApiName ) ) continue;

            rulePathFieldSettingByObjectNameAndFieldName.put(
                fieldToAddInQuery + FIELD_SETTING_COMPOSITE_SEPARATOR + objectApiName
                , new BR_RulePathFieldSettingBuilder()
                    .withName( fieldToAddInQuery )
                    .withRelatedSObjectAPIName( objectApiName )
                    .build()
            );
        }

        return rulePathFieldSettingByObjectNameAndFieldName;

    }

}