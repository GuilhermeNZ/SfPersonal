/**
 * @description: Test class for BusinessRulesSettingHandler
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class BusinessRulesSettingHandlerTest {

    @isTest 
    private static void insertRulePathSetting() {

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'Field1=Value1;Field2=Value2', 'TestObject'
        ).getRecord();

        Test.startTest();

        insert businessRulesSetting;

        Test.stopTest();

        RulePathSObjectSetting__c rulePathSObjectSetting = [SELECT Id, Name, FieldsToUseInQuery__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSetting, 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'TestObject', rulePathSObjectSetting.Name, 'Name field must be: TestObject' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Field1' ), 'Should contains Field1 in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Field2' ), 'Should contains Field2 in FieldsToUseInQuery__c field' );
    }

    @isTest
    private static void updateRulePathSetting() {

        TriggerHandler.bypass( 'BusinessRulesSettingHandler' );

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'Field1=Value1', 'TestObject'
        ).createRecord();

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        RulePathSObjectSetting__c rulePathSetting = (RulePathSObjectSetting__c) new RulePathSObjectSettingFactory.DefaultRT(
            'TestObject', 'Field1'
        ).createRecord();

        Test.startTest();

        businessRulesSetting.RuleKey__c = 'Field1=Value1;Field2=Value2';
        update businessRulesSetting;

        Test.stopTest();

        RulePathSObjectSetting__c rulePathSObjectSetting = [SELECT Id, Name, FieldsToUseInQuery__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSetting, 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'TestObject', rulePathSObjectSetting.Name, 'Name field must be: TestObject' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Field1' ), 'Should contains Field1 in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Field2' ), 'Should contains Field2 in FieldsToUseInQuery__c field' );
    }

}