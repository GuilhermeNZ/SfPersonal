/**
 * @description: Mock for BusinessRulesSettingRepository class
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class BusinessRulesSettingRepositoryMock extends BusinessRulesSettingRepository {

    String payload = '';

    public BusinessRulesSettingRepositoryMock( String payload ) {
        this.payload = payload;
    }

    public override List<BusinessRulesSetting__c> findByObjectNamesAndIsActivatedAndQueryLimit( Set<String> objectNames, Boolean isActivated, Integer queryLimit ) {
        return (List<BusinessRulesSetting__c>) JSON.deserialize( this.payload, List<BusinessRulesSetting__c>.class );
    }

}