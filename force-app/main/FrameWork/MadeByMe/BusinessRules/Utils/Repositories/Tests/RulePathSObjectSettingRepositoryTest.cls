/**
 * @description: Test class for RulePathSObjectSettingRepository
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class RulePathSObjectSettingRepositoryTest {

    private static void shouldFindByObjectAPINames() {

        RulePathSObjectSetting__c rulePathSObjectSetting = BR_RulePathSObjectSettingFixtureFactory.createRecord(
            'TestName'
        );

        Test.startTest();

        RulePathSObjectSettingRepository repository = RulePathSObjectSettingRepository.getInstance();
        List<RulePathSObjectSetting__c> rulePathSObjectSettings = repository.findByObjectAPINames( new List<String>{'TestName'} );

        Test.stopTest();

        Assert.isFalse( rulePathSObjectSettings.isEmpty(), 'Must return rulePathSObjectSettings' );
        Assert.areEqual( 1, rulePathSObjectSettings.size(), 'Must return one rulePathSObjectSetting' );
        Assert.areEqual( 'TestName', rulePathSObjectSettings[0].Name, 'Name field must be: TestName' );

    }

}