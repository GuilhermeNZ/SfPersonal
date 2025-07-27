/**
 * @description: Factory to create BusinessRulesSetting__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public inherited sharing class BR_BusinessRulesSettingFixtureFactory {

    public static BusinessRulesSetting__c createRecord( String name, Boolean isActivated, String ruleKey, String objectName ) {
        return createRecord( buildRecord( name, isActivated, ruleKey, objectName ) );
    }
    
    public static BusinessRulesSetting__c buildRecord( String name, Boolean isActivated, String ruleKey, String objectName ) {
        return new BusinessRulesSetting__c(
            Name = name
            , isActivated__c = isActivated
            , RuleKey__c = ruleKey
            , Object__c = objectName
        );
    }

    public static BusinessRulesSetting__c createRecord( BusinessRulesSetting__c businessRulesSetting ) {
        insert businessRulesSetting;
        return businessRulesSetting;
    }

    public static BusinessRulesSetting__c fromJson( String payload ){
        return (BusinessRulesSetting__c) JSON.deserialize( payload, BusinessRulesSetting__c.class );
    }
    
    public static List<BusinessRulesSetting__c> fromJsonArray( String payload ){
        return (List<BusinessRulesSetting__c>) JSON.deserialize( payload, List<BusinessRulesSetting__c>.class );
    }

}