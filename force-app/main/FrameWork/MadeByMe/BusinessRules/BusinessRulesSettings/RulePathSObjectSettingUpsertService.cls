/*
 * @description: Service class for RulePathSObjectSetting__c SObject Upsert Operations
 * @author Guilherme Zwipp
**/
public with sharing class RulePathSObjectSettingUpsertService {

    private RulePathSObjectSettingRepository repository;
    private BusinessRulesSettingValidator validator;

    public RulePathSObjectSettingUpsertService(){
        this.repository = RulePathSObjectSettingRepository.getInstance();
        this.validator = new BusinessRulesSettingValidator();
    }
    
    public List<RulePathSObjectSetting__c> byBusinessRulesSettingsRuleKey( List<BusinessRulesSetting__c> newBusinessRulesSettings, Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById ) {

        List<String> objectNames = Lists.byField( newBusinessRulesSettings, 'Object__c' );

        List<RulePathSObjectSetting__c> rulePathSObjectSettingsInOrg = this.repository.findByNames( objectNames );

        Map<String, RulePathSObjectSetting__c> rulePathSObjectSettingByObjectName = rulePathSObjectSettingsInOrg.isEmpty() ? new Map<String, RulePathSObjectSetting__c>()
            : (Map<String, RulePathSObjectSetting__c>) Maps.indexBy( 'Name' , rulePathSObjectSettingsInOrg );

        Map<String,Schema.DescribeSobjectResult> describeSObjectByName = this.getDescribreSObjectByName( objectNames );

        for( BusinessRulesSetting__c newBusinessRulesSetting : newBusinessRulesSettings ) {
            if( String.isBlank( newBusinessRulesSetting.RuleKey__c ) ) continue;

            String stringDifference = newBusinessRulesSetting.RuleKey__c;

            if( oldBusinessRulesSettingById != null && oldBusinessRulesSettingById.containsKey( newBusinessRulesSetting.Id ) ) {
                BusinessRulesSetting__c oldBusinessRulesSetting = oldBusinessRulesSettingById.get( newBusinessRulesSetting.Id );
                if( !String.isBlank( oldBusinessRulesSetting.RuleKey__c ) ) stringDifference = oldBusinessRulesSetting.RuleKey__c.difference( stringDifference );
            }

            if( String.isBlank( stringDifference ) ) continue;

            RulePathSObjectSetting__c rulePathSObjectSetting = rulePathSObjectSettingByObjectName.containsKey( newBusinessRulesSetting.Object__c ) ?
                rulePathSObjectSettingByObjectName.get( newBusinessRulesSetting.Object__c )
                : new RulePathSObjectSetting__c(Name = newBusinessRulesSetting.Object__c,FieldsToUseInQuery__c='');

            List<String> fieldsToAddInQuery = this.getFieldsToAddInQueryByBusinessRulesSettingRuleKey( stringDifference );

            this.validator.ruleKeyFieldsIsValid( fieldsToAddInQuery, describeSObjectByName, newBusinessRulesSetting );

            if( newBusinessRulesSetting.hasErrors() ) continue;

            for( String fieldToAddInQuery : fieldsToAddInQuery ) {
                if( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( fieldToAddInQuery ) ) continue;
                rulePathSObjectSetting.FieldsToUseInQuery__c += ',' + fieldToAddInQuery;
            }

            rulePathSObjectSetting.FieldsToUseInQuery__c = rulePathSObjectSetting.FieldsToUseInQuery__c.removeStart( ',' );

            rulePathSObjectSettingByObjectName.put( rulePathSObjectSetting.Name, rulePathSObjectSetting );
        }

        return this.repository.save( rulePathSObjectSettingByObjectName.values() );
    }

    private Map<String,Schema.DescribeSobjectResult> getDescribreSObjectByName( List<String> objectNames ) {

        Map<String,Schema.DescribeSobjectResult> describeSObjectByName = new Map<String,Schema.DescribeSobjectResult>();

        for( Schema.DescribeSobjectResult result : Schema.describeSObjects( objectNames ) ) {
            describeSObjectByName.put( result.getName(), result );
        }

        return describeSObjectByName;
    }

    private List<String> getFieldsToAddInQueryByBusinessRulesSettingRuleKey( String ruleKeyStringDifference ) {

        List<String> fieldsToAddInQuery = new List<String>();

        for( String fieldAndValue : ruleKeyStringDifference.split(';') ) {
            if( String.isBlank( fieldAndValue ) ) continue;
            fieldsToAddInQuery.add( fieldAndValue.split( '=' )[0].replace( ' ', '' ) );
        }

        return fieldsToAddInQuery;
    }

}