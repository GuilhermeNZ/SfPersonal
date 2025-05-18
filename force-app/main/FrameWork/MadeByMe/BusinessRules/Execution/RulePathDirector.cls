/**
 * @description: Class to enrich and update RulePath Object By a Sequence of Business Rules
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathDirector {
   
    private static RulePathDirector instance = null;

    public static RulePathDirector getInstance(){
        if( instance == null ) instance = new RulePathDirector();
        return instance;
    }

    private RulePathEnricher enricher;
    private RulePathRepository repository;
    private RulePathFilter filter;

    private RulePathDirector(){
        this.enricher = RulePathEnricher.getInstance();
        this.repository = RulePathRepository.getInstance();
        this.filter = RulePathFilter.getInstance();
    }

    public List<RulePath__c> enrichNextRuleWithStatusInAnalisy( List<RulePath__c> rulesPaths ) {

        List<RulePath__c> rulesPathsInOrg = this.repository.findBySequenceKeysAndIsActiveAndIsDisabled(
            new Set<String>( Lists.byField( rulesPaths, 'SequenceKey__c' ) )
            , true, false
        );

        List<RulePath__c> quoteRulesPathsToFilter = this.repository.findBySObjectIdsAndStatusAndIsActivatedAndIsDisabled(
            this.provideSObjectIdsToPutNextRulesInAnalisy( rulesPathsInOrg )
            , '', true, false
        );

        return this.repository.save(
            this.enricher.withStatus( this.filter.byFirstSequence( quoteRulesPathsToFilter ), 'EM_ANALISE' )
        );
    }

    public Set<String> provideSObjectIdsToPutNextRulesInAnalisy( List<RulePath__c> rulesPaths ) {
        return this.provideSObjectIdsByRuleMetBySObjectId( this.provideRuleMetBySObjectId( rulesPaths ) );
    }

    private Map<String,Boolean> provideRuleMetBySObjectId( List<RulePath__c> rulesPaths ) {

        Map<String,Boolean> ruleMetBySObjectId = new Map<String,Boolean>();

        for( RulePath__c rulePath : rulesPaths ) {

            if( !ruleMetBySObjectId.containsKey( rulePath.SObjectId__c ) ) ruleMetBySObjectId.put( rulePath.SObjectId__c, true );

            if( ruleMetBySObjectId.get( rulePath.SObjectId__c ) == false ) continue;

            if( rulePath.Status__c == RulePathPicklistValues.STATUS_BY_CONST.get( 'REGRA_ATENDIDA' ) ) continue;

            ruleMetBySObjectId.put( rulePath.SObjectId__c, false );
        }

        return ruleMetBySObjectId;
    }

    private Set<String> provideSObjectIdsByRuleMetBySObjectId( Map<String,Boolean> ruleMetBySObjectId ) {

        Set<String> sObjectIds = new Set<String>();

        for( String sObjectId : ruleMetBySObjectId.keySet() ) {
            if( ruleMetBySObjectId.get( sObjectId ) == false ) continue;
            sObjectIds.add( sObjectId );
        }

        return sObjectIds;
    }

}