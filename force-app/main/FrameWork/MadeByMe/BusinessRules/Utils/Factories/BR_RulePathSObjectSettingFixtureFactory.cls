/**
 * @description: Factory to create RulePathSObjectSetting__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public inherited sharing class BR_RulePathSObjectSettingFixtureFactory {

    public static RulePathSObjectSetting__c createRecord( String objectApiName ) {
        return createRecord( buildRecord( objectApiName ) );
    }
    
    public static RulePathSObjectSetting__c buildRecord( String objectApiName ) {
        return new RulePathSObjectSetting__c(
            ObjectAPIName__c = objectApiName
        );
    }

    public static RulePathSObjectSetting__c createRecord( RulePathSObjectSetting__c rulePathSObjectSetting ) {
        insert rulePathSObjectSetting;
        return rulePathSObjectSetting;
    }

}