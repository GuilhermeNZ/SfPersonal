/**
 * @description: Test class for BusinessRulesSettingHandler
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class BusinessRulesSettingHandlerTest {

    @isTest 
    private static void insertRulePathSetting() {

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'Name=TestName;Object__c=Account', 'BusinessRulesSetting__c'
        ).getRecord();

        Test.startTest();

        insert businessRulesSetting;

        Test.stopTest();

        RulePathSObjectSetting__c rulePathSObjectSetting = [SELECT Id, Name, FieldsToUseInQuery__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSetting, 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSetting.Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Name' ), 'Should contains Name in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Object__c' ), 'Should contains Object__c in FieldsToUseInQuery__c field' );
    }

    @isTest
    private static void updateRulePathSetting() {

        TriggerHandler.bypass( 'BusinessRulesSettingHandler' );

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'Name=TestName', 'BusinessRulesSetting__c'
        ).createRecord();

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        RulePathSObjectSetting__c rulePathSetting = (RulePathSObjectSetting__c) new RulePathSObjectSettingFactory.DefaultRT(
            'BusinessRulesSetting__c', 'Name'
        ).createRecord();

        Test.startTest();

        businessRulesSetting.RuleKey__c = 'Name=TestName;Object__c=Account';
        update businessRulesSetting;

        Test.stopTest();

        RulePathSObjectSetting__c rulePathSObjectSetting = [SELECT Id, Name, FieldsToUseInQuery__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSetting, 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSetting.Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Name' ), 'Should contains Name in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSetting.FieldsToUseInQuery__c.contains( 'Object__c' ), 'Should contains Object__c in FieldsToUseInQuery__c field' );
    }

    @isTest 
    private static void dontInsertRulePathSettingInvalidFieldError() {

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'InvalidField=InvalidValue;InvalidField2=InvalidValue2', 'BusinessRulesSetting__c'
        ).getRecord();

        Test.startTest();

        try{
            insert businessRulesSetting;
            Assert.isTrue( false, 'Must throw a exception' );
        }catch( DMLException error ){
            Assert.isTrue( true, 'Must throw a exception' );
            Assert.areEqual( Label.BusinessRulesInvalidFields + ' InvalidField,InvalidField2', error.getDmlMessage(0), 'BusinessRulesSetting__c error message must be: ' + Label.BusinessRulesInvalidFields + ' InvalidField,InvalidField2' );
        }

        Test.stopTest();

        List<RulePathSObjectSetting__c> rulePathSObjectSettings = [SELECT Id, Name, FieldsToUseInQuery__c FROM RulePathSObjectSetting__c];

        Assert.isTrue( rulePathSObjectSettings.isEmpty(), 'Must dont return rulePathSObjectSettings' );
    }

    @isTest
    private static void dontUpdateRulePathSettingInvalidFieldError() {

        TriggerHandler.bypass( 'BusinessRulesSettingHandler' );

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'Name=TestName', 'BusinessRulesSetting__c'
        ).createRecord();

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        RulePathSObjectSetting__c rulePathSetting = (RulePathSObjectSetting__c) new RulePathSObjectSettingFactory.DefaultRT(
            'BusinessRulesSetting__c', 'Name'
        ).createRecord();

        Test.startTest();

        try{
            businessRulesSetting.RuleKey__c = 'Name=TestName;InvalidField=InvalidValue';
            update businessRulesSetting;
            Assert.isTrue( false, 'Must throw a exception' );
        }catch( DMLException error ){
            Assert.isTrue( true, 'Must throw a exception' );
            Assert.areEqual( Label.BusinessRulesInvalidFields + ' InvalidField', error.getDmlMessage(0), 'BusinessRulesSetting__c error message must be: ' + Label.BusinessRulesInvalidFields + ' InvalidField' );
        }

        Test.stopTest();

        RulePathSObjectSetting__c rulePathSObjectSetting = [SELECT Id, Name, FieldsToUseInQuery__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSetting, 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSetting.Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.areEqual( 'Name', rulePathSObjectSetting.FieldsToUseInQuery__c, 'FieldsToUseInQuery__c field must be: Name' );
    }

}