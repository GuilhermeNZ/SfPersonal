/**
 * @description: Test class for RulePathCreatorService
 * @author: Guilherme Zwipp
 */
@isTest
public class RulePathCreatorServiceTest {

    @isTest
    private static void shouldCreateRulePathsBySObjectId() {

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestName'
            , true
            , 'Name=TestName'
            , 'BusinessRulesSetting__c'
        ).createRecord();

        Assert.areEqual( 1, [SELECT Id FROM RulePathSObjectSetting__c WHERE Name = 'BusinessRulesSetting__c'].size(), 'Must create one RulePathSObjectSetting__c' );

        BusinessRulesPath__c businessRulesPath = (BusinessRulesPath__c) new BR_BusinessRulesPathFactory.BR_ExampleValidationRule(
            businessRulesSetting.Id
            , true
            , 1
        ).createRecord();

        Test.startTest();

        RulePathCreatorService service = new RulePathCreatorService();
        List<RulePath__c> createdRulePaths = service.bySObjectIdCreate( businessRulesSetting.Id );

        Test.stopTest();

        Assert.isFalse( createdRulePaths.isEmpty(), 'Must return createdRulePaths' );
        Assert.areEqual( 1, createdRulePaths.size(), 'Must return one rulesPath' );
        Assert.areEqual( businessRulesSetting.Id, createdRulePaths[0].SObjectId__c, 'RulePath SObjectId__c field must be: ' + businessRulesSetting.Id );
        Assert.areEqual( businessRulesPath.Id, createdRulePaths[0].BusinessRulesPath__c, 'RulePath BusinessRulesPath__c field must be: ' + businessRulesPath.Id );
        Assert.areEqual( businessRulesPath.Name, createdRulePaths[0].Name, 'RulePath Name field must be: ' + businessRulesPath.Name );

    }

    @isTest
    private static void shouldCreateRulePathsBySObjectIds() {

        BusinessRulesSetting__c firstBusinessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'BusinessRulesSettingExample'
            , true
            , 'Name=BusinessRulesSettingExample'
            , 'BusinessRulesSetting__c'
        ).getRecord();

        BusinessRulesSetting__c secondBusinessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'BusinessRulesPathExample'
            , true
            , 'Name=BR_ExampleTwoValidationRule'
            , 'BusinessRulesPath__c'
        ).getRecord();

        insert new List<BusinessRulesSetting__c>{ firstBusinessRulesSetting, secondBusinessRulesSetting };

        Assert.areEqual(
            2
            , [SELECT Id FROM RulePathSObjectSetting__c WHERE Name = 'BusinessRulesPath__c' OR Name = 'BusinessRulesSetting__c'].size()
            , 'Must create two RulePathSObjectSetting__c'
        );

        BusinessRulesPath__c pathForFirstSetting = (BusinessRulesPath__c) new BR_BusinessRulesPathFactory.BR_ExampleValidationRule(
            firstBusinessRulesSetting.Id
            , true
            , 1
        ).getRecord();

        BusinessRulesPath__c pathForSecondSetting = (BusinessRulesPath__c) new BR_BusinessRulesPathFactory.BR_ExampleTwoValidationRule(
            secondBusinessRulesSetting.Id
            , true
            , 1
        ).getRecord();

        insert new List<BusinessRulesPath__c>{ pathForFirstSetting, pathForSecondSetting };

        Test.startTest();

        RulePathCreatorService service = new RulePathCreatorService();
        List<RulePath__c> createdRulePaths = service.bySObjectIdsCreate(
            new List<Id>{ firstBusinessRulesSetting.Id, pathForSecondSetting.Id } 
        );

        Test.stopTest();

        Assert.isFalse( createdRulePaths.isEmpty(), 'Must return createdRulePaths' );
        Assert.areEqual( 2, createdRulePaths.size(), 'Must return one rulesPath' );

        Map<String,List<RulePath__c>> rulesPathsBySObjectId = (Map<String,List<RulePath__c>>) Maps.groupBy( 'SObjectId__c', createdRulePaths );

        Assert.isTrue( rulesPathsBySObjectId.containsKey( firstBusinessRulesSetting.Id ) );
        List<RulePath__c> rulePathsForFirstSetting = rulesPathsBySObjectId.get( firstBusinessRulesSetting.Id );

        Assert.areEqual( 1, rulePathsForFirstSetting.size(), 'Must return one rulesPath related to BusinessRulesSetting' );
        Assert.areEqual( firstBusinessRulesSetting.Id, rulePathsForFirstSetting[0].SObjectId__c, 'RulePath related to BusinessRulesSetting SObjectId__c field must be: ' + firstBusinessRulesSetting.Id );
        Assert.areEqual( pathForFirstSetting.Id, rulePathsForFirstSetting[0].BusinessRulesPath__c, 'RulePath related to BusinessRulesSetting BusinessRulesPath__c field must be: ' + pathForFirstSetting.Id );
        Assert.areEqual( pathForFirstSetting.Name, rulePathsForFirstSetting[0].Name, 'RulePath related to BusinessRulesSetting Name field must be: ' + pathForFirstSetting.Name );

        Assert.isTrue( rulesPathsBySObjectId.containsKey( pathForSecondSetting.Id ) );
        List<RulePath__c> rulePathsForSecondSetting = rulesPathsBySObjectId.get( pathForSecondSetting.Id );

        Assert.areEqual( 1, rulePathsForSecondSetting.size(), 'Must return one rulesPath related to BusinessRulesSetting' );
        Assert.areEqual( pathForSecondSetting.Id, rulePathsForSecondSetting[0].SObjectId__c, 'RulePath related to pathForSecondSetting SObjectId__c field must be: ' + pathForSecondSetting.Id );
        Assert.areEqual( pathForSecondSetting.Id, rulePathsForSecondSetting[0].BusinessRulesPath__c, 'RulePath related to pathForSecondSetting BusinessRulesPath__c field must be: ' + pathForSecondSetting.Id );
        Assert.areEqual( pathForSecondSetting.Name, rulePathsForSecondSetting[0].Name, 'RulePath related to pathForSecondSetting Name field must be: ' + pathForSecondSetting.Name );
    }

    @isTest 
    private static void shouldThrowRulePathSObjectSettingMissingException() {

        TriggerHandler.bypass( 'BusinessRulesSettingHandler' );
        
        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestName'
            , true
            , 'Name=TestName'
            , 'BusinessRulesSetting__c'
        ).createRecord();

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        Assert.areEqual( 0, [SELECT Id FROM RulePathSObjectSetting__c WHERE Name = 'BusinessRulesSetting__c'].size(), 'Must dont create RulePathSObjectSetting__c' );

        Test.startTest();

        try{
            RulePathCreatorService service = new RulePathCreatorService();
            List<RulePath__c> createdRulePaths = service.bySObjectIdCreate( businessRulesSetting.Id );
            Assert.fail( 'Must throw a exception' );
        }catch( Exception error ) {
            Assert.isTrue( error.getMessage().contains( 'RulePathSObjectSetting__c not found to SObject' ) );
        }

        Test.stopTest();

    }

    @isTest 
    private static void shouldThrowRulePathSObjectSettingFieldsToUseInQueryBlankException() {

        TriggerHandler.bypass( 'BusinessRulesSettingHandler' );

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestName'
            , true
            , ''
            , 'BusinessRulesSetting__c'
        ).createRecord();

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        RulePathSObjectSetting__c rulePathSObjectSetting = (RulePathSObjectSetting__c) new RulePathSObjectSettingFactory.DefaultRT(
            'BusinessRulesSetting__c'
        ).createRecord();

        Test.startTest();

        try{
            RulePathCreatorService service = new RulePathCreatorService();
            List<RulePath__c> createdRulePaths = service.bySObjectIdCreate( businessRulesSetting.Id );
            Assert.fail( 'Must throw a exception' );
        }catch( Exception error ) {
            Assert.isTrue( error.getMessage().contains( 'is missing FieldsToUseInQuery__c' ) );
        }

        Test.stopTest();

    }

    @isTest
    private static void shouldDontCreateRulesPathBusinessRulesPathEmpty() {

        BusinessRulesSetting__c businessRulesSetting = (BusinessRulesSetting__c) new BusinessRulesSettingFactory.DefaultRT(
            'TestName'
            , true
            , 'Name=TestName'
            , 'BusinessRulesSetting__c'
        ).createRecord();

        Assert.areEqual( 1, [SELECT Id FROM RulePathSObjectSetting__c WHERE Name = 'BusinessRulesSetting__c'].size(), 'Must create one RulePathSObjectSetting__c' );

        Test.startTest();

        RulePathCreatorService service = new RulePathCreatorService();
        List<RulePath__c> createdRulePaths = service.bySObjectIdCreate( businessRulesSetting.Id );

        Test.stopTest();

        Assert.isTrue( createdRulePaths.isEmpty(), 'Must not return createdRulePaths' );

    }

}
