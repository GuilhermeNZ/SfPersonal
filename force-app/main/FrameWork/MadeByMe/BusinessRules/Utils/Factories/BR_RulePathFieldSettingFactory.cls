/**
 * @description: Factory to create RulePathFieldSetting__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class BR_RulePathFieldSettingFactory {
    
    private static RulePathFieldSetting__c buildNew( String name, String rulePathSObjectSettingId ) {
        return new RulePathFieldSetting__c(
            Name = name
            , RulePathSObjectSetting__c = rulePathSObjectSettingId
        );
    }

    public class DefaultRT extends SObjectFactory{

        public DefaultRT( String name, String rulePathSObjectSettingId ) {
            super( buildNew( name, rulePathSObjectSettingId ) );
        }

    }

}