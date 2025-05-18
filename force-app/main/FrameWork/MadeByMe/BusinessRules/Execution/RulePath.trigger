/**
 * @description: Unique trigger for RulePath__c
 * @author: Guilherme Zwipp
 */
trigger RulePath on RulePath__c ( before insert, before update, after insert, after update ) {
    new RulePathHandler().run();
}