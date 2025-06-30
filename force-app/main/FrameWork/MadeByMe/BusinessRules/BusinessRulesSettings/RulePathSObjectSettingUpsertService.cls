/*
 * @description: Service class for RulePathSObjectSetting__c SObject Upsert Operations
 * @author Guilherme Zwipp
**/
public with sharing class RulePathSObjectSettingUpsertService {

    private RulePathSObjectSettingRepository repository;
    private BusinessRulesSettingValidator validator;

    public RulePathSObjectSettingUpsertService(){
        this.repository = RulePathSObjectSettingRepository.getInstance();
        this.validator = BusinessRulesSettingValidator.getInstance();
    }

    private static final String RULE_KEY_DELIMITER = ';';
    
    public List<RulePathSObjectSetting__c> byBusinessRulesSettingsRuleKey( List<BusinessRulesSetting__c> newBusinessRulesSettings, Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById ) {

        List<String> objectNames = Lists.byField( newBusinessRulesSettings, 'Object__c' );

        Map<String, RulePathSObjectSetting__c> rulePathSObjectSettingByObjectName = (Map<String, RulePathSObjectSetting__c>) Maps.indexBy(
            'Name'
            , this.repository.findByNames( objectNames )
            , Map<String, RulePathSObjectSetting__c>.class
        );

        Map<String,Schema.DescribeSobjectResult> describeSObjectByName = SObjectHelper.getDescribreSObjectByName( objectNames );

        return this.repository.save(
            this.getBusinessRulesSettingsToUpsert(
                newBusinessRulesSettings
                , oldBusinessRulesSettingById
                , rulePathSObjectSettingByObjectName
                , describeSObjectByName
            )
        );
    }

    private List<RulePathSObjectSetting__c> getBusinessRulesSettingsToUpsert(
        List<BusinessRulesSetting__c> newBusinessRulesSettings
        , Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById
        , Map<String, RulePathSObjectSetting__c> rulePathSObjectSettingByObjectName
        , Map<String,Schema.DescribeSobjectResult> describeSObjectByName
    ) {
        for( BusinessRulesSetting__c newBusinessRulesSetting : newBusinessRulesSettings ) {
            if( String.isBlank( newBusinessRulesSetting.RuleKey__c ) ) continue;

            String ruleKeyDifference = this.getRuleKeyFieldsDifference( newBusinessRulesSetting, oldBusinessRulesSettingById );
            if( String.isBlank( ruleKeyDifference ) ) continue;

            RulePathSObjectSetting__c rulePathSObjectSetting = this.getOrCreateRulePathSetting( rulePathSObjectSettingByObjectName, newBusinessRulesSetting );

            List<String> fieldsToAddInQuery = this.extractFieldsFromRuleKeyDifference( ruleKeyDifference );

            this.validator.ruleKeyFieldsIsValid( fieldsToAddInQuery, describeSObjectByName, newBusinessRulesSetting );
            if( newBusinessRulesSetting.hasErrors() ) continue;

            rulePathSObjectSetting.FieldsToUseInQuery__c = this.mergeQueryFields( rulePathSObjectSetting.FieldsToUseInQuery__c, fieldsToAddInQuery );

            rulePathSObjectSettingByObjectName.put( rulePathSObjectSetting.Name, rulePathSObjectSetting );
        }

        return rulePathSObjectSettingByObjectName.values();
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
            .withName( newBusinessRulesSetting.Object__c )
            .withFieldsToUseInQuery( '' )
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

    private String mergeQueryFields( String fieldsToUseInQuery, List<String> fieldsToAddInQuery ) {

        Set<String> fieldSet = new Set<String>();

        if ( !String.isBlank( fieldsToUseInQuery ) ) {
            fieldSet.addAll( fieldsToUseInQuery.split( ',' ) );
        }

        fieldSet.addAll( fieldsToAddInQuery );
        return String.join( new List<String>( fieldSet ), ',' );

    }

}