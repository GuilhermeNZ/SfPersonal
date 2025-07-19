/**
 * @description: Factory to create RulePathSObjectSetting__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class RulePathSObjectSettingFactory {

    private static RulePathSObjectSetting__c buildNew( String objectApiName ) {
        return new RulePathSObjectSetting__c(
            ObjectAPIName__c = objectApiName
        );
    }

    public class DefaultRT extends SObjectFactory{

        public DefaultRT( String objectApiName ) {
            super( buildNew( objectApiName ) );
        }

    }

}