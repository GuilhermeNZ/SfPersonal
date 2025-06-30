/**
 * @description: Unique trigger for BusinessRulesSetting__c
 * @author: Guilherme Zwipp
 */
trigger BusinessRulesSetting on BusinessRulesSetting__c ( after insert, after update ) {
    new BusinessRulesSettingHandler().run();
}