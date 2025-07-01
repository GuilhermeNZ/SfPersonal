/**
 * @description: Mock for BR_RulePathFieldSettingRepository class
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class BR_RulePathFieldSettingRepositoryMock extends BR_RulePathFieldSettingRepository {

    String payload = '';

    public BR_RulePathFieldSettingRepositoryMock( String payload ) {
        this.payload = payload;
    }

    public override List<RulePathFieldSetting__c> findByObjectNames( List<String> objectNames ) {
        return (List<RulePathFieldSetting__c>) JSON.deserialize( this.payload , List<RulePathFieldSetting__c>.class );
    }

    
    public override List<SObject> save (List<SObject> aggregates) {
        return aggregates;
    }

}