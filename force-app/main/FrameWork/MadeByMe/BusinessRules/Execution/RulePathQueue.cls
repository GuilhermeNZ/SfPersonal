/**
 * @description: Class responsible to enqueue RulePath executions
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class RulePathQueue implements Queueable,Database.AllowsCallouts {

    private List<RulePath__c> rulesPaths;

    public RulePathQueue( List<RulePath__c> rulesPaths ) {
        this.rulesPaths = rulesPaths;
    }

    public void execute( QueueableContext context ) {
        RulePathExecuteService.getInstance().executeRules( this.rulesPaths );
    }

}