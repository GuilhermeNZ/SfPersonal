/**
 * @description: Test class for BusinessRulesSettingFinder
 * @author: Guilherme Zwipp
 */
@isTest
private class BusinessRulesSettingFinderTest {

    @isTest
    private static void shouldReturnBusinessRulesSettingWhenMatchFoundWithOneSObjectType() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );
        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"Account","RuleKey__c":"Name=AccountTest"}]';

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( businessRulesSettingsPayload ) );

        List<Account> accounts = (List<Account>) JSON.deserialize( '[{"Id":"'+accountFakeId+'","Name":"AccountTest"}]', List<Account>.class );

        Test.startTest();

        BusinessRulesSettingFinder finder = BusinessRulesSettingFinder.getInstance();
        Map<String, BusinessRulesSetting__c> businessRulesSettingByObjectId = finder.byRecordsAndSObjectApiNames( accounts, new Set<String>{ 'Account' } );

        Test.stopTest();

        Assert.isFalse( businessRulesSettingByObjectId.isEmpty(), 'Must return businessRulesSettingByObjectId' );
        Assert.areEqual( 1, businessRulesSettingByObjectId.keySet().size(), 'Must return only one key in the map businessRulesSettingByObjectId' );
        Assert.isTrue( businessRulesSettingByObjectId.containsKey( accountFakeId ), 'Must contains in the map the key: ' + accountFakeId );
        Assert.areEqual( businessRulesSettingFakeId, businessRulesSettingByObjectId.get( accountFakeId ).Id, 'The BusinessRulesSetting__c returned must have the Id: ' + businessRulesSettingFakeId );
    }

    @isTest
    private static void shouldReturnSettingWhenAllRuleKeyFieldsMatchRecord() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );
        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"Account","RuleKey__c":"Name=AccountTest;Id='+accountFakeId+'"}]';

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( businessRulesSettingsPayload ) );

        List<Account> accounts = (List<Account>) JSON.deserialize( '[{"Id":"'+accountFakeId+'","Name":"AccountTest"}]', List<Account>.class );

        Test.startTest();

        BusinessRulesSettingFinder finder = BusinessRulesSettingFinder.getInstance();
        Map<String, BusinessRulesSetting__c> businessRulesSettingByObjectId = finder.byRecordsAndSObjectApiNames( accounts, new Set<String>{ 'Account' } );

        Test.stopTest();

        Assert.isFalse( businessRulesSettingByObjectId.isEmpty(), 'Must return businessRulesSettingByObjectId' );
        Assert.areEqual( 1, businessRulesSettingByObjectId.keySet().size(), 'Must return only one key in the map businessRulesSettingByObjectId' );
        Assert.isTrue( businessRulesSettingByObjectId.containsKey( accountFakeId ), 'Must contains in the map the key: ' + accountFakeId );
        Assert.areEqual( businessRulesSettingFakeId, businessRulesSettingByObjectId.get( accountFakeId ).Id, 'The BusinessRulesSetting__c returned must have the Id: ' + businessRulesSettingFakeId );
    }

    @isTest
    private static void shouldReturnBusinessRulesSettingWhenMatchFoundWithTwoSObjectType() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );
        String leadFakeId = FixtureFactory.generateFakeId18( Lead.getSObjectType() );
        List<String> businessRulesSettingFakeIds = FixtureFactory.generateFakeIds18( BusinessRulesSetting__c.getSObjectType(), 2 );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeIds[0]+'","Object__c":"Account","RuleKey__c":"Name=AccountTest"},{"Id":"'+businessRulesSettingFakeIds[1]+'","Object__c":"Lead","RuleKey__c":"Name=LeadTest"}]';

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( businessRulesSettingsPayload ) );

        Account account = (Account) JSON.deserialize( '{"Id":"'+accountFakeId+'","Name":"AccountTest"}', Account.class );
        Lead lead = (Lead) JSON.deserialize( '{"Id":"'+leadFakeId+'","Name":"LeadTest"}', Lead.class );

        Test.startTest();

        BusinessRulesSettingFinder finder = BusinessRulesSettingFinder.getInstance();
        Map<String, BusinessRulesSetting__c> businessRulesSettingByObjectId = finder.byRecordsAndSObjectApiNames(
            new List<SObject>{ account, lead }, new Set<String>{ 'Account', 'Lead' } 
        );

        Test.stopTest();

        Assert.isFalse( businessRulesSettingByObjectId.isEmpty(), 'Must return businessRulesSettingByObjectId' );
        Assert.areEqual( 2, businessRulesSettingByObjectId.keySet().size(), 'Must return only one key in the map businessRulesSettingByObjectId' );
        
        Assert.isTrue( businessRulesSettingByObjectId.containsKey( accountFakeId ), 'Must contains in the map the key: ' + accountFakeId );
        Assert.areEqual( businessRulesSettingFakeIds[0], businessRulesSettingByObjectId.get( accountFakeId ).Id, 'The BusinessRulesSetting__c returned must have the Id: ' + businessRulesSettingFakeIds[0] );

        Assert.isTrue( businessRulesSettingByObjectId.containsKey( leadFakeId ), 'Must contains in the map the key: ' + leadFakeId );
        Assert.areEqual( businessRulesSettingFakeIds[1], businessRulesSettingByObjectId.get( leadFakeId ).Id, 'The BusinessRulesSetting__c returned must have the Id: ' + businessRulesSettingFakeIds[1] );
    }

    @isTest
    private static void shouldThrowExceptionWhenNoSettingsForSObjectType() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( '[]' ) );

        List<Account> accounts = (List<Account>) JSON.deserialize( '[{"Id":"'+accountFakeId+'","Name":"AccountTest"}]', List<Account>.class );

        Test.startTest();

        try {
            BusinessRulesSettingFinder.getInstance().byRecordsAndSObjectApiNames( accounts, new Set<String>{ 'Account' } );
            Assert.fail( 'Must have thrown BusinessRulesSettingFinderException' );
        } catch( BusinessRulesSettingFinderException error ) {
            Assert.isTrue( error.getMessage().contains( 'No BusinessRulesSetting__c found' ), 'Exception message must contains: No BusinessRulesSetting__c found' );
        }

        Test.stopTest();
    }

    @isTest
    private static void shouldThrowExceptionWhenNoMatchingSetting() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );
        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"Account","RuleKey__c":"Name=AccountTest"}]';

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( businessRulesSettingsPayload ) );

        List<Account> accounts = (List<Account>) JSON.deserialize( '[{"Id":"'+accountFakeId+'","Name":"InvalidName"}]', List<Account>.class );

        Test.startTest();

        try {
            BusinessRulesSettingFinder.getInstance().byRecordsAndSObjectApiNames( accounts, new Set<String>{ 'Account' } );
            Assert.fail( 'Must have thrown BusinessRulesSettingFinderException' );
        } catch( BusinessRulesSettingFinderException error ) {
            Assert.isTrue( error.getMessage().contains( 'No matching BusinessRulesSetting__c found' ), 'Exception message must contains: No matching BusinessRulesSetting__c found' );
        }

        Test.stopTest();
    }

    @isTest
    private static void shouldSkipRuleWhenRuleKeyIsEmpty() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );
        List<String> businessRulesSettingFakeIds = FixtureFactory.generateFakeIds18( BusinessRulesSetting__c.getSObjectType(), 2 );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeIds[0]+'","Object__c":"Account","RuleKey__c":null},{"Id":"'+businessRulesSettingFakeIds[1]+'","Object__c":"Account","RuleKey__c":"Name=AccountTest"}]';

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( businessRulesSettingsPayload ) );

        List<Account> accounts = (List<Account>) JSON.deserialize( '[{"Id":"'+accountFakeId+'","Name":"AccountTest"}]', List<Account>.class );

        Test.startTest();

        BusinessRulesSettingFinder finder = BusinessRulesSettingFinder.getInstance();
        Map<String, BusinessRulesSetting__c> businessRulesSettingByObjectId = finder.byRecordsAndSObjectApiNames( accounts, new Set<String>{ 'Account' } );

        Test.stopTest();

        Assert.isFalse( businessRulesSettingByObjectId.isEmpty(), 'Must return businessRulesSettingByObjectId' );
        Assert.areEqual( 1, businessRulesSettingByObjectId.keySet().size(), 'Must return only one key in the map businessRulesSettingByObjectId' );
        Assert.isTrue( businessRulesSettingByObjectId.containsKey( accountFakeId ), 'Must contains in the map the key: ' + accountFakeId );
        Assert.areEqual( businessRulesSettingFakeIds[1], businessRulesSettingByObjectId.get( accountFakeId ).Id, 'The BusinessRulesSetting__c returned must have the Id: ' + businessRulesSettingFakeIds[1] );
    }

    @isTest
    private static void shouldSkipRuleWhenRuleKeyIsMalformed() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );
        List<String> businessRulesSettingFakeIds = FixtureFactory.generateFakeIds18( BusinessRulesSetting__c.getSObjectType(), 2 );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeIds[0]+'","Object__c":"Account","RuleKey__c":"Name=AccountTest;InvalidKey"},{"Id":"'+businessRulesSettingFakeIds[1]+'","Object__c":"Account","RuleKey__c":"Name=AccountTest"}]';

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( businessRulesSettingsPayload ) );

        List<Account> accounts = (List<Account>) JSON.deserialize( '[{"Id":"'+accountFakeId+'","Name":"AccountTest"}]', List<Account>.class );

        Test.startTest();

        BusinessRulesSettingFinder finder = BusinessRulesSettingFinder.getInstance();
        Map<String, BusinessRulesSetting__c> businessRulesSettingByObjectId = finder.byRecordsAndSObjectApiNames( accounts, new Set<String>{ 'Account' } );

        Test.stopTest();

        Assert.isFalse( businessRulesSettingByObjectId.isEmpty(), 'Must return businessRulesSettingByObjectId' );
        Assert.areEqual( 1, businessRulesSettingByObjectId.keySet().size(), 'Must return only one key in the map businessRulesSettingByObjectId' );
        Assert.isTrue( businessRulesSettingByObjectId.containsKey( accountFakeId ), 'Must contains in the map the key: ' + accountFakeId );
        Assert.areEqual( businessRulesSettingFakeIds[1], businessRulesSettingByObjectId.get( accountFakeId ).Id, 'The BusinessRulesSetting__c returned must have the Id: ' + businessRulesSettingFakeIds[1] );
    }

    @isTest
    private static void shouldReturnSettingWhenMatchingRuleKeyWithNullFieldValue() {
        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSObjectType() );
        String businessRulesSettingFakeId = FixtureFactory.generateFakeId18( BusinessRulesSetting__c.getSObjectType() );

        String businessRulesSettingsPayload = '[{"Id":"'+businessRulesSettingFakeId+'","Object__c":"Account","RuleKey__c":"Name=null"}]';

        BusinessRulesSettingRepository.setMock( new BusinessRulesSettingRepositoryMock( businessRulesSettingsPayload ) );

        List<Account> accounts = (List<Account>) JSON.deserialize( '[{"Id":"'+accountFakeId+'","Name":null}]', List<Account>.class );

        Test.startTest();

        BusinessRulesSettingFinder finder = BusinessRulesSettingFinder.getInstance();
        Map<String, BusinessRulesSetting__c> businessRulesSettingByObjectId = finder.byRecordsAndSObjectApiNames( accounts, new Set<String>{ 'Account' } );

        Test.stopTest();

        Assert.isFalse( businessRulesSettingByObjectId.isEmpty(), 'Must return businessRulesSettingByObjectId' );
        Assert.areEqual( 1, businessRulesSettingByObjectId.keySet().size(), 'Must return only one key in the map businessRulesSettingByObjectId' );
        Assert.isTrue( businessRulesSettingByObjectId.containsKey( accountFakeId ), 'Must contains in the map the key: ' + accountFakeId );
        Assert.areEqual( businessRulesSettingFakeId, businessRulesSettingByObjectId.get( accountFakeId ).Id, 'The BusinessRulesSetting__c returned must have the Id: ' + businessRulesSettingFakeId );
    }

}
