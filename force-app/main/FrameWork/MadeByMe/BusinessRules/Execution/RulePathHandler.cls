/*
 * @description: Trigger handler for the SObject RulePath__c
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathHandler extends TriggerHandler {
        
    private List<RulePath__c> newRulePaths;
	private Map<Id, RulePath__c> oldRulePathById;

    private RulePathFilter filter;
    private RulePathEnricher enricher;
    private RulePathDirector director;
    private RulePathAfterExecutionService afterExecutionService;
    private RulePathSLATrackerService slaTrackerService;

    //private QuoteDirector quoteDirectorInstance;

    public RulePathHandler() {
		this.newRulePaths = (List<RulePath__c>) Trigger.new;
		this.oldRulePathById = (Map<Id, RulePath__c>) Trigger.oldMap;

        this.filter = RulePathFilter.getInstance();
        this.enricher = RulePathEnricher.getInstance();
        this.director = RulePathDirector.getInstance();
        this.afterExecutionService = RulePathAfterExecutionService.getInstance();
        this.slaTrackerService = RulePathSLATrackerService.getInstance();

        //this.quoteDirectorInstance = QuoteDirector.getInstance();
	}

    public override void beforeInsert() {
        this.putFirstRuleInAnalisy( this.newRulePaths );
        this.enrichStatusTracker( this.newRulePaths, this.oldRulePathById );
    }

    public override void afterInsert() {
        this.executeFirstRules( this.newRulePaths );
    }

    public override void beforeUpdate(){
        this.enrichStatusTracker( this.newRulePaths, this.oldRulePathById );
    }

    public override void afterUpdate(){
        this.putNextRuleInAnalisy( this.newRulePaths, this.oldRulePathById );
        this.afterReprovedActions( this.newRulePaths, this.oldRulePathById );
        //this.updateQuoteStatusAfterRulesExecution( this.newRulePaths, this.oldRulePathById );
        this.executeNextRules( this.newRulePaths, this.oldRulePathById );
    }

    private void putFirstRuleInAnalisy( List<RulePath__c> rulesPaths ) {

        List<RulePath__c> firstRulesPaths = this.filter.byFirstSequence( rulesPaths );

        if( firstRulesPaths.isEmpty() ) return;

        this.enricher.withStatus( firstRulesPaths, 'EM_ANALISE' );
    }

    private void executeFirstRules( List<RulePath__c> rulesPaths ) {

        List<RulePath__c> rulesPathInAnalisy = this.filter.byStatus( rulesPaths, 'EM_ANALISE' );

        if( rulesPathInAnalisy.isEmpty() ) return;

        System.enqueueJob( new RulePathQueue( rulesPathInAnalisy ) );
    }

    private void putNextRuleInAnalisy( List<RulePath__c> rulesPaths, Map<Id, RulePath__c> oldRulePathById ) {

        List<RulePath__c> rulesPathsWithStatusRuleMet = this.filter.relevantChangeRecordsFilter(
            rulesPaths, oldRulePathById, 'Status__c', RulePathPicklistValues.STATUS_BY_CONST.get( 'REGRA_ATENDIDA' )
        );

        if( rulesPathsWithStatusRuleMet.isEmpty() ) return;

        this.director.enrichNextRuleWithStatusInAnalisy( rulesPathsWithStatusRuleMet );

    }

    private void executeNextRules( List<RulePath__c> rulesPaths, Map<Id, RulePath__c> oldRulePathById ) {

        List<RulePath__c> rulesPathsInAnalisy = this.filter.relevantChangeRecordsFilter( 
            rulesPaths, oldRulePathById, 'Status__c', RulePathPicklistValues.STATUS_BY_CONST.get( 'EM_ANALISE' )
        );

        if( rulesPathsInAnalisy.isEmpty() ) return;

        System.enqueueJob( new RulePathQueue( rulesPathsInAnalisy ) );
    }

    //Working
    // private void updateQuoteStatusAfterRulesExecution( List<RulePath__c> rulesPaths, Map<Id, RulePath__c> oldRulePathById ) {
    //     List<RulePath__c> quoteRulesPathsWithStatusRuleMetAndNotMet = this.filter.relevantChangeRecordsFilter(
    //         rulesPaths, oldRulePathById, 'Status__c', new List<String>{'Regra Atendida', 'Regra nao Atendida'}
    //     );

    //     if( quoteRulesPathsWithStatusRuleMetAndNotMet.isEmpty() ) return;

    //     this.quoteDirectorInstance.enrichAfterQuoteRulesExecution( quoteRulesPathsWithStatusRuleMetAndNotMet );
    // }

    private void afterReprovedActions( List<RulePath__c> rulesPaths, Map<Id, RulePath__c> oldRulePathById ) {

        List<RulePath__c> reprovedRulesPaths = this.filter.relevantChangeRecordsFilter(
            rulesPaths, oldRulePathById, 'Status__c', RulePathPicklistValues.STATUS_BY_CONST.get( 'REGRA_NAO_ATENDIDA' )
        );

        if( reprovedRulesPaths.isEmpty() ) return;

        this.afterExecutionService.reprovedActions( reprovedRulesPaths );
    }

    private void enrichStatusTracker( List<RulePath__c> rulesPaths, Map<Id,RulePath__c> oldRulePathById ) {

        List<RulePath__c> rulesPathsWithStatusChanged = this.filter.relevantChangeRecordsFilter(
            rulesPaths, oldRulePathById, new List<String>{'Status__c'}
        );

        if( rulesPathsWithStatusChanged.isEmpty() ) return;

        this.slaTrackerService.enrichStatusTrackerFields( rulesPathsWithStatusChanged, oldRulePathById );

    }

}