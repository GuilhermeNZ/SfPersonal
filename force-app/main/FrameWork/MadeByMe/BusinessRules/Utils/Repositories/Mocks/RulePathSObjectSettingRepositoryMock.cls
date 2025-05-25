/**
 * @description: Mock for RulePathSObjectSettingRepository class
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class RulePathSObjectSettingRepositoryMock extends RulePathSObjectSettingRepository{
    
    String payload = '';

    public RulePathSObjectSettingRepositoryMock( String payload ) {
        this.payload = payload;
    }

    public override RulePathSObjectSetting__c findByName( String name ) {
        return (RulePathSObjectSetting__c) JSON.deserialize( this.payload, RulePathSObjectSetting__c.class );
    }

    public override List<RulePathSObjectSetting__c> findByNames( List<String> names ) {
        return (List<RulePathSObjectSetting__c>) JSON.deserialize( this.payload, List<RulePathSObjectSetting__c>.class );
    }

    public override List<SObject> save (List<SObject> aggregates) {
        return aggregates;
    }

}