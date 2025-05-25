/**
 * @description: Factory to create RulePathSObjectSetting__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class RulePathSObjectSettingFactory {

    private static RulePathSObjectSetting__c buildNew( String name, String fieldsToUseInQuery ) {
        return new RulePathSObjectSetting__c(
            Name = name
            , FieldsToUseInQuery__c = fieldsToUseInQuery
        );
    }

    public class DefaultRT extends SObjectFactory{

        public DefaultRT( String name ) {
            super( buildNew( name, '' ) );
        }

        public DefaultRT( String name, String fieldsToUseInQuery ) {
            super( buildNew( name, fieldsToUseInQuery ) );
        }

    }

}