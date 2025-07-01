/**
 * @description: Test class for RulePathSObjectSettingUpsertService
 * @author: Guilherme Zwipp
 */
@isTest
private class RulePathSObjectSettingUpsertServiceTest {

    @isTest
    private static void dontUpsertEmptyNewBusinessRulesSettings() {
        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( '[]' ) );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( new List<BusinessRulesSetting__c>(), null );

        Test.stopTest();

        Assert.isTrue( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be empty' );
        Assert.isTrue( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be empty' );
    }

    @isTest
    private static void dontUpsertNewBusinessRulesSettingRuleKeyIsBlank() {
        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( '[]' ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":null}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.isTrue( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be empty' );
        Assert.isTrue( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be empty' );
    }

    @isTest 
    private static void createInInsertingScenario() {
        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( '[]' ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.isFalse( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be not empty' );
        Assert.isFalse( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be not empty' );

        Assert.areEqual( 1, result.get( 'RulePathSObjectSetting__c' ).size(), 'Must return one RulePathSObjectSetting__c' );
        Assert.areEqual( 2, result.get( 'RulePathFieldSetting__c' ).size(), 'Must return two RulePathFieldSetting__c' );

        Assert.areEqual( 'BusinessRulesSetting__c', ( (RulePathSObjectSetting__c) result.get( 'RulePathSObjectSetting__c' )[0] ).ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );
    
        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByName = (Map<String,RulePathFieldSetting__c>) Maps.indexBy(
            'Name'
            , result.get( 'RulePathFieldSetting__c' )
            , Map<String,RulePathFieldSetting__c>.class
        );

        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Name' ), 'Should contains Name in RulePathFieldSetting' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Object__c' ), 'Should contains Object__c in RulePathFieldSetting' );
    }

    @isTest 
    private static void createInUpdateScenarioOldKeyValueBlank() {
        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( '[]' ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":""}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.isFalse( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be not empty' );
        Assert.isFalse( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be not empty' );

        Assert.areEqual( 1, result.get( 'RulePathSObjectSetting__c' ).size(), 'Must return one RulePathSObjectSetting__c' );
        Assert.areEqual( 2, result.get( 'RulePathFieldSetting__c' ).size(), 'Must return two RulePathFieldSetting__c' );

        Assert.areEqual( 'BusinessRulesSetting__c', ( (RulePathSObjectSetting__c) result.get( 'RulePathSObjectSetting__c' )[0] ).ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );
    
        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByName = (Map<String,RulePathFieldSetting__c>) Maps.indexBy(
            'Name'
            , result.get( 'RulePathFieldSetting__c' )
            , Map<String,RulePathFieldSetting__c>.class
        );

        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Name' ), 'Should contains Name in RulePathFieldSetting' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Object__c' ), 'Should contains Object__c in RulePathFieldSetting' );
    }

    @isTest 
    private static void createInInsertingTwoScenario() {
        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( '[]' ) );

        List<String> businessRulesSettingFakeIds = FixtureFactory.generateFakeIds18( BusinessRulesSetting__c.getSObjectType(), 2 );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeIds[0]+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"},{"Id":"'+businessRulesSettingFakeIds[1]+'","Object__c":"Account","RuleKey__c":"Id=TestId"}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.isFalse( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be not empty' );
        Assert.isFalse( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be not empty' );

        Assert.areEqual( 2, result.get( 'RulePathSObjectSetting__c' ).size(), 'Must return two RulePathSObjectSetting__c' );
        Assert.areEqual( 3, result.get( 'RulePathFieldSetting__c' ).size(), 'Must return three RulePathFieldSetting__c' );

        Map<String,RulePathSObjectSetting__c> rulePathSObjectSettingByName = (Map<String,RulePathSObjectSetting__c>) Maps.indexBy(
            'ObjectAPIName__c'
            , result.get( 'RulePathSObjectSetting__c' )
            , Map<String,RulePathSObjectSetting__c>.class
        );

        Assert.isTrue( rulePathSObjectSettingByName.containsKey( 'BusinessRulesSetting__c' ), 'Should contains BusinessRulesSetting__c in RulePathSObjectSetting' );
        Assert.isTrue( rulePathSObjectSettingByName.containsKey( 'Account' ), 'Should contains Account in RulePathSObjectSetting' );

        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByName = (Map<String,RulePathFieldSetting__c>) Maps.indexBy(
            'Name'
            , result.get( 'RulePathFieldSetting__c' )
            , Map<String,RulePathFieldSetting__c>.class
        );

        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Name' ), 'Should contains Name in RulePathFieldSetting' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Object__c' ), 'Should contains Object__c in RulePathFieldSetting' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Id' ), 'Should contains Id in RulePathFieldSetting' );
    }

    @isTest 
    private static void dontUpdateBusinessRuleRuleKeyDontChanged() {
        String rulePathSObjectSettingFakeId = FixtureFactory.generateFakeId18( RulePathSObjectSetting__c.getSObjectType() );

        String rulePathSObjectSettingsPayload = '[{"Id":"'+rulePathSObjectSettingFakeId+'","ObjectAPIName__c":"BusinessRulesSetting__c"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulePathSObjectSettingsPayload ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( '[]' ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.isFalse( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be not empty' );
        Assert.isTrue( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be empty' );

        Assert.areEqual( 1, result.get( 'RulePathSObjectSetting__c' ).size(), 'Must return one RulePathSObjectSetting__c' );

        Assert.areEqual( rulePathSObjectSettingFakeId, result.get( 'RulePathSObjectSetting__c' )[0].Id, 'Id field must be: ' + rulePathSObjectSettingFakeId );
        Assert.areEqual( 'BusinessRulesSetting__c', ( (RulePathSObjectSetting__c) result.get( 'RulePathSObjectSetting__c' )[0] ).ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );
    }

    @isTest 
    private static void dontUpdateBusinessSettingRuleKeyFieldAlreadyInQuery() {
        String rulePathSObjectSettingFakeId = FixtureFactory.generateFakeId18( RulePathSObjectSetting__c.getSObjectType() );
        List<String> rulePathFieldSettingFakeIds = FixtureFactory.generateFakeIds18( RulePathFieldSetting__c.getSObjectType(), 2 );

        String rulePathSObjectSettingsPayload = '[{"Id":"'+rulePathSObjectSettingFakeId+'","ObjectAPIName__c":"BusinessRulesSetting__c"}]';
        String rulePathFieldSettingsPayload = '[{"Id":"'+rulePathFieldSettingFakeIds[0]+'","Name":"Name","ObjectAPIName__c":"BusinessRulesSetting__c"},{"Id":"'+rulePathFieldSettingFakeIds[1]+'","Name":"Object__c","ObjectAPIName__c":"BusinessRulesSetting__c"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulePathSObjectSettingsPayload ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( rulePathFieldSettingsPayload ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.isFalse( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be not empty' );
        Assert.isFalse( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be not empty' );

        Assert.areEqual( 1, result.get( 'RulePathSObjectSetting__c' ).size(), 'Must return one RulePathSObjectSetting__c' );
        Assert.areEqual( 2, result.get( 'RulePathFieldSetting__c' ).size(), 'Must return two RulePathFieldSetting__c' );

        Assert.areEqual( rulePathSObjectSettingFakeId, result.get( 'RulePathSObjectSetting__c' )[0].Id, 'Id field must be: ' + rulePathSObjectSettingFakeId );
        Assert.areEqual( 'BusinessRulesSetting__c', ( (RulePathSObjectSetting__c) result.get( 'RulePathSObjectSetting__c' )[0] ).ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );
    
        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByName = (Map<String,RulePathFieldSetting__c>) Maps.indexBy(
            'Name'
            , result.get( 'RulePathFieldSetting__c' )
            , Map<String,RulePathFieldSetting__c>.class
        );

        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Name' ), 'Should contains Name in RulePathFieldSetting' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Object__c' ), 'Should contains Object__c in RulePathFieldSetting' );

        Assert.areEqual( rulePathFieldSettingFakeIds[0], rulePathFieldSettingByName.get( 'Name' ).Id, 'Id field must be: ' + rulePathFieldSettingFakeIds[0] );
        Assert.areEqual( rulePathFieldSettingFakeIds[1], rulePathFieldSettingByName.get( 'Object__c' ).Id, 'Id field must be: ' + rulePathFieldSettingFakeIds[1] );
    }

    @isTest
    private static void updateBusinessSettingRuleKeyFieldNotInQuery() {
        String rulePathSObjectSettingFakeId = FixtureFactory.generateFakeId18( RulePathSObjectSetting__c.getSObjectType() );
        String rulePathFieldSettingFakeId = FixtureFactory.generateFakeId18( RulePathFieldSetting__c.getSObjectType() );

        String rulePathSObjectSettingsPayload = '[{"Id":"'+rulePathSObjectSettingFakeId+'","ObjectAPIName__c":"BusinessRulesSetting__c"}]';
        String rulePathFieldSettingsPayload = '[{"Id":"'+rulePathFieldSettingFakeId+'","Name":"Name","ObjectAPIName__c":"BusinessRulesSetting__c"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulePathSObjectSettingsPayload ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( rulePathFieldSettingsPayload ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;Object__c=Account"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.isFalse( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be not empty' );
        Assert.isFalse( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be not empty' );

        Assert.areEqual( 1, result.get( 'RulePathSObjectSetting__c' ).size(), 'Must return one RulePathSObjectSetting__c' );
        Assert.areEqual( 2, result.get( 'RulePathFieldSetting__c' ).size(), 'Must return two RulePathFieldSetting__c' );

        Assert.areEqual( rulePathSObjectSettingFakeId, result.get( 'RulePathSObjectSetting__c' )[0].Id, 'Id field must be: ' + rulePathSObjectSettingFakeId );
        Assert.areEqual( 'BusinessRulesSetting__c', ( (RulePathSObjectSetting__c) result.get( 'RulePathSObjectSetting__c' )[0] ).ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );
    
        Map<String,RulePathFieldSetting__c> rulePathFieldSettingByName = (Map<String,RulePathFieldSetting__c>) Maps.indexBy(
            'Name'
            , result.get( 'RulePathFieldSetting__c' )
            , Map<String,RulePathFieldSetting__c>.class
        );

        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Name' ), 'Should contains Name in RulePathFieldSetting' );
        Assert.isTrue( rulePathFieldSettingByName.containsKey( 'Object__c' ), 'Should contains Object__c in RulePathFieldSetting' );

        Assert.areEqual( rulePathFieldSettingFakeId, rulePathFieldSettingByName.get( 'Name' ).Id, 'Id field must be: ' + rulePathFieldSettingFakeId );
        Assert.isNull( rulePathFieldSettingByName.get( 'Object__c' ).Id, 'Id field must be null' );
    }

    @isTest 
    private static void dontCreateBusinessSettingInvalidField() {
        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( '[]' ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( '[]' ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;InvalidField=InvalidValue"}]';

        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, null );

        Test.stopTest();

        Assert.isTrue( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be empty' );
        Assert.isTrue( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be empty' );

        Assert.isTrue( businessRulesSettings[0].hasErrors(), 'Should return field error' );
        Assert.areEqual( 1, businessRulesSettings[0].getErrors().size(), 'BusinessRulesSetting__c must contains only one error' );
        Assert.areEqual( Label.BusinessRulesInvalidFields + ' InvalidField', businessRulesSettings[0].getErrors()[0].getMessage(), 'BusinessRulesSetting__c error message must be: ' + Label.BusinessRulesInvalidFields + ' InvalidField' );
    }

    @isTest 
    private static void dontUpdateBusinessSettingInvalidField() {
        String rulePathSObjectSettingFakeId = FixtureFactory.generateFakeId18( RulePathSObjectSetting__c.getSObjectType() );
        String rulePathFieldSettingFakeId = FixtureFactory.generateFakeId18( RulePathFieldSetting__c.getSObjectType() );

        String rulePathSObjectSettingsPayload = '[{"Id":"'+rulePathSObjectSettingFakeId+'","ObjectAPIName__c":"BusinessRulesSetting__c"}]';
        String rulePathFieldSettingsPayload = '[{"Id":"'+rulePathFieldSettingFakeId+'","Name":"Name","ObjectAPIName__c":"BusinessRulesSetting__c"}]';

        RulePathSObjectSettingRepository.setMock( new RulePathSObjectSettingRepositoryMock( rulePathSObjectSettingsPayload ) );
        BR_RulePathFieldSettingRepository.setMock( new BR_RulePathFieldSettingRepositoryMock( rulePathFieldSettingsPayload ) );

        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String oldBusinessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName"}]';
        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"BusinessRulesSetting__c","RuleKey__c":"Name=TestName;InvalidField=InvalidValue"}]';

        List<BusinessRulesSetting__c> oldBusinessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( oldBusinessRulesSettingsPayload );
        List<BusinessRulesSetting__c> businessRulesSettings = BusinessRulesSettingFactory.fromJsonArray( businessRulesSettingsPayload );

        Test.startTest();

        RulePathSObjectSettingUpsertService service = new RulePathSObjectSettingUpsertService();
        Map<String,List<SObject>> result = service.byBusinessRulesSettingsRuleKey( businessRulesSettings, new Map<Id, BusinessRulesSetting__c>( oldBusinessRulesSettings ) );

        Test.stopTest();

        Assert.isFalse( result.get( 'RulePathSObjectSetting__c' ).isEmpty(), 'RulePathSObjectSetting__c must be not empty' );
        Assert.isFalse( result.get( 'RulePathFieldSetting__c' ).isEmpty(), 'RulePathFieldSetting__c must be not empty' );

        Assert.areEqual( 1, result.get( 'RulePathSObjectSetting__c' ).size(), 'Must return one RulePathSObjectSetting__c' );
        Assert.areEqual( 1, result.get( 'RulePathFieldSetting__c' ).size(), 'Must return one RulePathFieldSetting__c' );

        Assert.areEqual( rulePathSObjectSettingFakeId, result.get( 'RulePathSObjectSetting__c' )[0].Id, 'Id field must be: ' + rulePathSObjectSettingFakeId );
        Assert.areEqual( 'BusinessRulesSetting__c', ( (RulePathSObjectSetting__c) result.get( 'RulePathSObjectSetting__c' )[0] ).ObjectAPIName__c, 'ObjectAPIName__c field must be: BusinessRulesSetting__c' );

        Assert.areEqual( rulePathFieldSettingFakeId, result.get( 'RulePathFieldSetting__c' )[0].Id, 'RulePathFieldSetting__c Id must be: ' + rulePathFieldSettingFakeId );
        Assert.areEqual( 'Name', ( (RulePathFieldSetting__c) result.get( 'RulePathFieldSetting__c' )[0] ).Name, 'RulePathFieldSetting__c Name must be Name' );

        Assert.isTrue( businessRulesSettings[0].hasErrors(), 'Should return field error' );
        Assert.areEqual( 1, businessRulesSettings[0].getErrors().size(), 'BusinessRulesSetting__c must contains only one error' );
        Assert.areEqual( Label.BusinessRulesInvalidFields + ' InvalidField', businessRulesSettings[0].getErrors()[0].getMessage(), 'BusinessRulesSetting__c error message must be: ' + Label.BusinessRulesInvalidFields + ' InvalidField' );
    }

}