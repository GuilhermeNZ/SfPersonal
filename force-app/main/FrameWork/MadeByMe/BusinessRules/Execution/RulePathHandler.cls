/*
 * @description: Trigger handler for the SObject RulePath__c
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathHandler extends TriggerHandler {
        
    private List<RulePath__c> tNew;
	private List<RulePath__c> tOld;
	private Map<Id, RulePath__c> tNewMap;
	private Map<Id, RulePath__c> tOldMap;

    private RulePathFilter filter;
    private RulePathEnricher enricher;
    private RulePathDirector director;
    private RulePathAfterExecutionService afterExecutionService;
    private RulePathSLATrackerService slaTrackerService;

    //private QuoteDirector quoteDirectorInstance;

    public RulePathHandler() {
		this.tNew = (List<RulePath__c>) Trigger.new;
		this.tOld = (List<RulePath__c>) Trigger.old;
		this.tNewMap = (Map<Id, RulePath__c>) Trigger.newMap;
		this.tOldMap = (Map<Id, RulePath__c>) Trigger.oldMap;

        this.filter = RulePathFilter.getInstance();
        this.enricher = RulePathEnricher.getInstance();
        this.director = RulePathDirector.getInstance();
        this.afterExecutionService = RulePathAfterExecutionService.getInstance();
        this.slaTrackerService = RulePathSLATrackerService.getInstance();

        //this.quoteDirectorInstance = QuoteDirector.getInstance();
	}

    public override void beforeInsert() {
        this.putFirstRuleInAnalisy( this.tNew );
        this.enrichStatusTracker( this.tNew, this.tOldMap );
    }

    public override void afterInsert() {
        this.executeFirstRules( this.tNew );
    }

    public override void beforeUpdate(){
        this.enrichStatusTracker( this.tNew, this.tOldMap );
    }

    public override void afterUpdate(){
        this.putNextRuleInAnalisy( this.tNew, this.tOldMap );
        this.afterReprovedActions( this.tNew, this.tOldMap );
        //this.updateQuoteStatusAfterRulesExecution( this.tNew, this.tOldMap );
        this.executeNextRules( this.tNew, this.tOldMap );
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