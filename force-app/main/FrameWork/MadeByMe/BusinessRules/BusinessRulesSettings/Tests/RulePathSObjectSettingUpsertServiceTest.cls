/**
 * @description: Test class for RulePathSObjectSettingUpsertService
 * @author: Guilherme Zwipp
 */
@isTest
private class RulePathSObjectSettingUpsertServiceTest {

    @isTest
    private static void dontUpsertEmptyNewBusinessRulesSettings() {

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( new List<BusinessRulesSetting__c>(), null );

        Test.stopTest();

        Assert.areEqual( 0, rulePathSObjectSettingsEnriched.size(), 'rulePathSObjectSettingsEnriched must be empty' );
    }

    @isTest
    private static void dontUpsertNewBusinessRulesSettingRuleKeyIsBlank() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":null}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.areEqual( 0, rulePathSObjectSettingsEnriched.size(), 'rulePathSObjectSettingsEnriched must be empty' );
    }

    @isTest 
    private static void createOldBusinessRulesNull() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1;Field2=Value2"}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'TestObject', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: TestObject' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Field1' ), 'Should contains Field1 in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Field2' ), 'Should contains Field2 in FieldsToUseInQuery__c field' );
    }

    @isTest 
    private static void createNewBusinessRuleRuleKeyNotNull() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":""}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1;Field2=Value2"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'TestObject', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: TestObject' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Field1' ), 'Should contains Field1 in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Field2' ), 'Should contains Field2 in FieldsToUseInQuery__c field' );
    }

    @isTest 
    private static void dontUpdateBusinessRuleRuleKeyDontChanged() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String rulepathSObjectSettingsPayload = '[{"Name":"TestObject"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulepathSObjectSettingsPayload ) );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'TestObject', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: TestObject' );
        Assert.isTrue( String.isBlank( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c ), 'FieldsToUseInQuery__c field must be blank' );
    }

    @isTest 
    private static void dontUpdateBusinessSettingRuleKeyFieldAlreadyInQuery() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String rulepathSObjectSettingsPayload = '[{"Name":"TestObject","FieldsToUseInQuery__c":"Field1,Field2"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulepathSObjectSettingsPayload ) );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1;Field2=Value2"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'TestObject', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: TestObject' );
        Assert.areEqual( 'Field1,Field2', rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c, 'FieldsToUseInQuery__c field must be: Field1,Field2' );

    }

    @isTest
    private static void updateBusinessSettingRuleKeyFieldNotInQuery() {
        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String rulepathSObjectSettingsPayload = '[{"Name":"TestObject","FieldsToUseInQuery__c":"Field1"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulepathSObjectSettingsPayload ) );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"TestObject","RuleKey__c":"Field1=Value1;Field2=Value2"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'TestObject', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: TestObject' );
        Assert.areEqual( 'Field1,Field2', rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c, 'FieldsToUseInQuery__c field must be: Field1,Field2' );
    }

}
