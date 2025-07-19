/**
 * @description: Factory to create BusinessRulesSetting__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class BusinessRulesSettingFactory {

    public static BusinessRulesSetting__c buildNew( String name, Boolean isActivated, String ruleKey, String objectName ) {
        return new BusinessRulesSetting__c(
            Name = name
            , isActivated__c = isActivated
            , RuleKey__c = ruleKey
            , Object__c = objectName
        );
    }

    public class DefaultRT extends SObjectFactory{

        public DefaultRT( String name, Boolean isActivated, String ruleKey, String objectName ) {
            super( buildNew( name, isActivated, ruleKey, objectName ) );
        }

    }

    public static BusinessRulesSetting__c fromJson( String payload ){
        return (BusinessRulesSetting__c) JSON.deserialize( payload, BusinessRulesSetting__c.class );
    }
    
    public static List<BusinessRulesSetting__c> fromJsonArray( String payload ){
        return (List<BusinessRulesSetting__c>) JSON.deserialize( payload, List<BusinessRulesSetting__c>.class );
    }

}