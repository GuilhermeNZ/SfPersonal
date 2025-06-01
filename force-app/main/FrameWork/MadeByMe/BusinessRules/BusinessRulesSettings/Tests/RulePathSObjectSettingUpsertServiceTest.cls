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

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":null}]';

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

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Name' ), 'Should contains Name in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Object__c' ), 'Should contains Object__c in FieldsToUseInQuery__c field' );
    }

    @isTest 
    private static void createNewBusinessRuleRuleKeyNotNull() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":""}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Name' ), 'Should contains Name in FieldsToUseInQuery__c field' );
        Assert.isTrue( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c.contains( 'Object__c' ), 'Should contains Object__c in FieldsToUseInQuery__c field' );
    }

    @isTest 
    private static void dontUpdateBusinessRuleRuleKeyDontChanged() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String rulepathSObjectSettingsPayload = '[{"Name":"BusinessRulesSetting__c"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulepathSObjectSettingsPayload ) );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.isTrue( String.isBlank( rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c ), 'FieldsToUseInQuery__c field must be blank' );
    }

    @isTest 
    private static void dontUpdateBusinessSettingRuleKeyFieldAlreadyInQuery() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String rulepathSObjectSettingsPayload = '[{"Name":"BusinessRulesSetting__c","FieldsToUseInQuery__c":"Name,Object__c"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulepathSObjectSettingsPayload ) );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.areEqual( 'Name,Object__c', rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c, 'FieldsToUseInQuery__c field must be: Name,Object__c' );
    }

    @isTest
    private static void updateBusinessSettingRuleKeyFieldNotInQuery() {
        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String rulepathSObjectSettingsPayload = '[{"Name":"BusinessRulesSetting__c","FieldsToUseInQuery__c":"Name"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulepathSObjectSettingsPayload ) );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'BusinessRulesSetting__c', rulePathSObjectSettingsEnriched[0].Name, 'Name field must be: BusinessRulesSetting__c' );
        Assert.areEqual( 'Name,Object__c', rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c, 'FieldsToUseInQuery__c field must be: Name,Object__c' );
    }

    @isTest 
    private static void dontCreateBusinessSettingInvalidField() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;InvalidField=InvalidValue"}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.areEqual( 0, rulePathSObjectSettingsEnriched.size(), 'Must dont return rulePathSObjectSettingsEnriched' );
        Assert.isTrue( businessRulesSettings[0].hasErrors(), 'Should return field error' );
        Assert.areEqual( 1, businessRulesSettings[0].getErrors().size(), 'BusinessRulesSetting__c must contains only one error' );
        Assert.areEqual( Label.BusinessRulesInvalidFields + ' InvalidField', businessRulesSettings[0].getErrors()[0].getMessage(), 'BusinessRulesSetting__c error message must be: ' + Label.BusinessRulesInvalidFields + ' InvalidField' );
    }

    @isTest 
    private static void dontUpdateBusinessSettingInvalidField() {

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String rulepathSObjectSettingsPayload = '[{"Name":"BusinessRulesSetting__c","FieldsToUseInQuery__c":"Name"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulepathSObjectSettingsPayload ) );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;InvalidField=InvalidValue"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        List<RulePathSObjectSetting__c> rulePathSObjectSettingsEnriched =
            service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.areEqual( 1, rulePathSObjectSettingsEnriched.size(), 'Must return one rulePathSObjectSettingsEnriched' );
        Assert.areEqual( 'Name', rulePathSObjectSettingsEnriched[0].FieldsToUseInQuery__c, 'FieldsToUseInQuery__c field must be: Name' );
        Assert.isTrue( businessRulesSettings[0].hasErrors(), 'Should return field error' );
        Assert.areEqual( 1, businessRulesSettings[0].getErrors().size(), 'BusinessRulesSetting__c must contains only one error' );
        Assert.areEqual( Label.BusinessRulesInvalidFields + ' InvalidField', businessRulesSettings[0].getErrors()[0].getMessage(), 'BusinessRulesSetting__c error message must be: ' + Label.BusinessRulesInvalidFields + ' InvalidField' );
    }

}