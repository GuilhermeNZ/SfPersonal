/**
 * @description: Test class for RulePathCreatorService
 * @author: Guilherme Zwipp
 */
@isTest
public class RulePathCreatorServiceTest {

    @isTest
    private static void shouldCreateRulePathsBySObjectId() {

        BusinessRulesSetting__c businessRulesSetting = BR_BusinessRulesSettingFixtureFactory.createRecord(
            'TestName'
            , true
            , 'Name=TestName'
            , 'BusinessRulesSetting__c'
        );

        Assert.areEqual( 1, [SELECT Id FROM RulePathSObjectSetting__c WHERE ObjectAPIName__c = 'BusinessRulesSetting__c'].size(), 'Must create one RulePathSObjectSetting__c' );
        Assert.areEqual( 1, [SELECT Id FROM RulePathFieldSetting__c].size(), 'Must create one RulePathFieldSetting__c' );

        Map<String,SObject> businessRulesPathIntegratedScenario = BR_BusinessRulesPathFixtureFactory.exampleIntegratedScenario(
            businessRulesSetting.Id
            , true
            , 1
        );

        BusinessRulesPath__c businessRulesPath = (BusinessRulesPath__c) businessRulesPathIntegratedScenario.get( 'BusinessRulesPath__c' );

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

        BusinessRulesSetting__c firstBusinessRulesSetting = BR_BusinessRulesSettingFixtureFactory.createRecord(
            'BusinessRulesSettingExample'
            , true
            , 'Name=BusinessRulesSettingExample'
            , 'BusinessRulesSetting__c'
        );

        BusinessRulesSetting__c secondBusinessRulesSetting = BR_BusinessRulesSettingFixtureFactory.createRecord(
            'BusinessRulesPathExample'
            , true
            , 'Name=BR_ExampleTwoValidationRule'
            , 'BusinessRulesPath__c'
        );

        Assert.areEqual(
            2
            , [SELECT Id FROM RulePathSObjectSetting__c WHERE ObjectAPIName__c = 'BusinessRulesPath__c' OR ObjectAPIName__c = 'BusinessRulesSetting__c'].size()
            , 'Must create two RulePathSObjectSetting__c'
        );
        Assert.areEqual( 2, [SELECT Id FROM RulePathFieldSetting__c].size(), 'Must create two RulePathFieldSetting__c' );

        Map<String,SObject> exampleRulePathIntegratedScenario = BR_BusinessRulesPathFixtureFactory.exampleIntegratedScenario(
            firstBusinessRulesSetting.Id
            , true
            , 1
        );

        BusinessRulesPath__c pathForFirstSetting = (BusinessRulesPath__c) exampleRulePathIntegratedScenario.get( 'BusinessRulesPath__c' );

        Map<String,SObject> exampleTwoRulePathIntegratedScenario = BR_BusinessRulesPathFixtureFactory.exampleTwoIntegratedScenario(
            secondBusinessRulesSetting.Id
            , true
            , 1
        );

        BusinessRulesPath__c pathForSecondSetting = (BusinessRulesPath__c) exampleTwoRulePathIntegratedScenario.get( 'BusinessRulesPath__c' );

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

        BusinessRulesSetting__c businessRulesSetting = BR_BusinessRulesSettingFixtureFactory.createRecord(
            'TestName'
            , true
            , 'Name=TestName'
            , 'BusinessRulesSetting__c'
        );

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        Assert.areEqual( 0, [SELECT Id FROM RulePathSObjectSetting__c WHERE ObjectAPIName__c = 'BusinessRulesSetting__c'].size(), 'Must dont create RulePathSObjectSetting__c' );
        Assert.areEqual( 0, [SELECT Id FROM RulePathFieldSetting__c].size(), 'Must dont create RulePathFieldSetting__c' );

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

        BusinessRulesSetting__c businessRulesSetting = BR_BusinessRulesSettingFixtureFactory.createRecord(
            'TestName'
            , true
            , ''
            , 'BusinessRulesSetting__c'
        );

        TriggerHandler.clearBypass( 'BusinessRulesSettingHandler' );

        RulePathSObjectSetting__c rulePathSObjectSetting = BR_RulePathSObjectSettingFixtureFactory.createRecord(
            'BusinessRulesSetting__c'
        );

        Assert.areEqual( 0, [SELECT Id FROM RulePathFieldSetting__c].size(), 'Must dont create RulePathFieldSetting__c' );

        Test.startTest();

        try{
            RulePathCreatorService service = new RulePathCreatorService();
            List<RulePath__c> createdRulePaths = service.bySObjectIdCreate( businessRulesSetting.Id );
            Assert.fail( 'Must throw a exception' );
        }catch( Exception error ) {
            Assert.isTrue( error.getMessage().contains( 'is missing Field to Query' ) );
        }

        Test.stopTest();

    }

    @isTest
    private static void shouldDontCreateRulesPathBusinessRulesPathEmpty() {

        BusinessRulesSetting__c businessRulesSetting = BR_BusinessRulesSettingFixtureFactory.createRecord(
            'TestName'
            , true
            , 'Name=TestName'
            , 'BusinessRulesSetting__c'
        );

        Assert.areEqual( 1, [SELECT Id FROM RulePathSObjectSetting__c WHERE ObjectAPIName__c = 'BusinessRulesSetting__c'].size(), 'Must create one RulePathSObjectSetting__c' );
        Assert.areEqual( 1, [SELECT Id FROM RulePathFieldSetting__c].size(), 'Must create one RulePathFieldSetting__c' );

        Test.startTest();

        RulePathCreatorService service = new RulePathCreatorService();
        List<RulePath__c> createdRulePaths = service.bySObjectIdCreate( businessRulesSetting.Id );

        Test.stopTest();

        Assert.isTrue( createdRulePaths.isEmpty(), 'Must not return createdRulePaths' );

    }

}
