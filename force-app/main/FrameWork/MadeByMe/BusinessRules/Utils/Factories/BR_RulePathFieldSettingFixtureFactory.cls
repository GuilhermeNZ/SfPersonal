/**
 * @description: Factory to create RulePathFieldSetting__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public inherited sharing class BR_RulePathFieldSettingFixtureFactory {

    public static RulePathFieldSetting__c createRecord( String name, String rulePathSObjectSettingId ) {
        return createRecord( buildRecord( name, rulePathSObjectSettingId ) );
    }
    
    public static RulePathFieldSetting__c buildRecord( String name, String rulePathSObjectSettingId ) {
        return new RulePathFieldSetting__c(
            Name = name
            , RulePathSObjectSetting__c = rulePathSObjectSettingId
        );
    }

    public static RulePathFieldSetting__c createRecord( RulePathFieldSetting__c rulePathFieldSetting ) {
        insert rulePathFieldSetting;
        return rulePathFieldSetting;
    }

}