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

        RulePathSObjectSetting__c rulePathSObjectSetting = [SELECT Id, ObjectAPIName__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSetting, 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSetting.ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );

        List<RulePathFieldSetting__c> rulePathFieldSettings = [SELECT Id, Name, RulePathSObjectSetting__c FROM RulePathFieldSetting__c];

        Assert.isFalse( rulePathFieldSettings.isEmpty(), 'Must return rulePathFieldSettings' );
        Assert.areEqual( 2, rulePathFieldSettings.size(), 'Must return two rulePathFieldSettings' );

        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByName = (Map<String,RulePathFieldSetting__c>) Maps.indexBy(
            'Name', rulePathFieldSettings, Map<String,RulePathFieldSetting__c>.class
        );

        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Name' ), 'Should contains Name in rulePathFieldSettingByName map' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Object__c' ), 'Should contains Object__c in rulePathFieldSettingByName map' );

        Assert.areEqual( rulePathSObjectSetting.id, rulePathFieldSettingByName.get( 'Name' ).RulePathSObjectSetting__c, 'RulePathSObjectSetting__c must be: ' + rulePathSObjectSetting.id );
        Assert.areEqual( rulePathSObjectSetting.id, rulePathFieldSettingByName.get( 'Object__c' ).RulePathSObjectSetting__c, 'RulePathSObjectSetting__c must be: ' + rulePathSObjectSetting.id );
    }

    @isTest
    private static void updateRulePathSetting() {

        TriggerHandler.bypass( 'BusinessRulesSettingHandler' );

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'Name=TestName', 'BusinessRulesSetting__c'
        ).createRecord();

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        RulePathSObjectSetting__c rulePathSetting = (RulePathSObjectSetting__c) new RulePathSObjectSettingFactory.DefaultRT(
            'BusinessRulesSetting__c'
        ).createRecord();

        RulePathFieldSetting__c rulePathFieldSetting = (RulePathFieldSetting__c) new BR_RulePathFieldSettingFactory.DefaultRT(
            'Name', rulePathSetting.Id
        ).createRecord();

        Test.startTest();

        businessRulesSetting.RuleKey__c = 'Name=TestName;Object__c=Account';
        update businessRulesSetting;

        Test.stopTest();

        RulePathSObjectSetting__c rulePathSObjectSetting = [SELECT Id, ObjectAPIName__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSetting, 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSetting.ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );

        List<RulePathFieldSetting__c> rulePathFieldSettings = [SELECT Id, Name, RulePathSObjectSetting__c FROM RulePathFieldSetting__c];

        Assert.isFalse( rulePathFieldSettings.isEmpty(), 'Must return rulePathFieldSettings' );
        Assert.areEqual( 2, rulePathFieldSettings.size(), 'Must return two rulePathFieldSettings' );

        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByName = (Map<String,RulePathFieldSetting__c>) Maps.indexBy(
            'Name', rulePathFieldSettings, Map<String,RulePathFieldSetting__c>.class
        );

        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Name' ), 'Should contains Name in rulePathFieldSettingByName map' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Object__c' ), 'Should contains Object__c in rulePathFieldSettingByName map' );

        Assert.areEqual( rulePathSObjectSetting.id, rulePathFieldSettingByName.get( 'Name' ).RulePathSObjectSetting__c, 'RulePathSObjectSetting__c must be: ' + rulePathSObjectSetting.id );
        Assert.areEqual( rulePathSObjectSetting.id, rulePathFieldSettingByName.get( 'Object__c' ).RulePathSObjectSetting__c, 'RulePathSObjectSetting__c must be: ' + rulePathSObjectSetting.id );
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

        List<RulePathSObjectSetting__c> rulePathSObjectSettings = [SELECT Id, ObjectAPIName__c FROM RulePathSObjectSetting__c];

        Assert.isTrue( rulePathSObjectSettings.isEmpty(), 'Must dont return rulePathSObjectSettings' );

        List<RulePathFieldSetting__c> rulePathFieldSettings = [SELECT Id, Name FROM RulePathFieldSetting__c];

        Assert.isTrue( rulePathFieldSettings.isEmpty(), 'Must not return rulePathFieldSettings' );
    }

    @isTest
    private static void dontUpdateRulePathSettingInvalidFieldError() {

        TriggerHandler.bypass( 'BusinessRulesSettingHandler' );

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestRuleSetting', true, 'Name=TestName', 'BusinessRulesSetting__c'
        ).createRecord();

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        RulePathSObjectSetting__c rulePathSetting = (RulePathSObjectSetting__c) new RulePathSObjectSettingFactory.DefaultRT(
            'BusinessRulesSetting__c'
        ).createRecord();

        RulePathFieldSetting__c rulePathFieldSetting = (RulePathFieldSetting__c) new BR_RulePathFieldSettingFactory.DefaultRT(
            'Name', rulePathSetting.Id
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

        RulePathSObjectSetting__c rulePathSObjectSettingAfterUpdate = [SELECT Id, ObjectAPIName__c FROM RulePathSObjectSetting__c];

        Assert.isNotNull( rulePathSObjectSettingAfterUpdate, 'Must return one rulePathSObjectSettingAfterUpdate' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSettingAfterUpdate.ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );

        RulePathFieldSetting__c rulePathFieldSettingAfterUpdate = [SELECT Id, Name, RulePathSObjectSetting__c FROM RulePathFieldSetting__c WHERE Id = :rulePathFieldSetting.Id];
        Assert.isNotNull( rulePathFieldSettingAfterUpdate, 'Must return one rulePathFieldSetting' );
        Assert.areEqual( 'Name', rulePathFieldSettingAfterUpdate.Name, 'Name field must be: Name' );
        Assert.areEqual( rulePathSetting.Id, rulePathFieldSettingAfterUpdate.RulePathSObjectSetting__c, 'RulePathSObjectSetting__c must be the same' );
    }

}