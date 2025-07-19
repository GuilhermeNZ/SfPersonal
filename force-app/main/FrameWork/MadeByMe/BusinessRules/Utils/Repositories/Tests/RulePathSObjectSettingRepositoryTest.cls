/**
 * @description: Test class for RulePathSObjectSettingRepository
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class RulePathSObjectSettingRepositoryTest {

    private static void shouldFindByNames() {

        RulePathSObjectSetting__c rulePathSObjectSetting = (RulePathSObjectSetting__c)
            new RulePathSObjectSettingFactory.DefaultRT( 'TestName' ).createRecord();

        Test.startTest();

        RulePathSObjectSettingRepository repository = new RulePathSObjectSettingRepository();
        List<RulePathSObjectSetting__c> rulePathSObjectSettings = repository.findByNames( new List<String>{'TestName'} );

        Test.stopTest();

        Assert.isFalse( rulePathSObjectSettings.isEmpty(), 'Must return rulePathSObjectSettings' );
        Assert.areEqual( 1, rulePathSObjectSettings.size(), 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'TestName', rulePathSObjectSettings[0].Name, 'Name field must be: TestName' );

    }

}