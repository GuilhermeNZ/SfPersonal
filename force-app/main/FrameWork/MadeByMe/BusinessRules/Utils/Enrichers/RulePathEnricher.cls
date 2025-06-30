/**
 * @description: Enricher class for RulePath__c object
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathEnricher {
    
    private static RulePathEnricher instance = null;

    public static RulePathEnricher getInstance() {
        if( instance == null ) instance = new RulePathEnricher();
        return instance;
    }

    private RulePathEnricher(){}

    private RulePath__c rulePathInstance = null;

    public RulePathEnricher newInstance( String id ) {
        this.rulePathInstance = new RulePath__c(
            Id = id
        );
        return this;
    }

    public RulePath__c withStatusAndErrorMessageAndDataUsed( String status, String errorMessage, String dataUsed ) {
        return this.withStatusAndErrorMessageAndDataUsed( this.rulePathInstance, status, errorMessage, dataUsed );
    }

    public RulePath__c withStatusAndErrorMessageAndDataUsed( RulePath__c rulePath, String status, String errorMessage, String dataUsed ) {
        rulePath = this.withStatusAndErrorMessage( rulePath, status, errorMessage );
        rulePath = this.withDataUsed( rulePath, dataUsed );

        return rulePath;
    }

    public RulePath__c withStatusInAnalisyAndExecuteSubRule() {
        return this.withStatusInAnalisyAndExecuteSubRule( this.rulePathInstance );
    }

    public RulePath__c withStatusInAnalisyAndExecuteSubRule( RulePath__c rulePath ) {
        rulePath = this.withStatus( rulePath, 'EM_ANALISE' );
        rulePath = this.withExecuteSubRule( rulePath, true );

        return rulePath;
    }

    public List<RulePath__c> newInstanceWithStatusAndErrorMessage( List<RulePath__c> rulesPaths, String status, String errorMessage ) {
        List<RulePath__c> enrichedRulesPath = new List<RulePath__c>();

        for( RulePath__c rulePath : rulesPaths ) {
            enrichedRulesPath.add( this.newInstance( rulePath.Id ).withStatusAndErrorMessage( status, errorMessage ) );
        }

        return enrichedRulesPath;
    }

    public List<RulePath__c> withStatusAndErrorMessage( List<RulePath__c> rulesPaths, String status, String errorMessage ) {
        List<RulePath__c> enrichedRulesPath = new List<RulePath__c>();

        for( RulePath__c rulePath : rulesPaths ) {
            enrichedRulesPath.add( this.withStatusAndErrorMessage( rulePath, status, errorMessage ) );
        }

        return enrichedRulesPath;
    }

    public RulePath__c withStatusAndErrorMessage( String status, String errorMessage ) {
        return this.withStatusAndErrorMessage( this.rulePathInstance, status, errorMessage );
    }

    public RulePath__c withStatusAndErrorMessage( RulePath__c rulePath, String status, String errorMessage ) {
        rulePath = this.withStatus( rulePath, status );
        rulePath = this.withErrorMessage( rulePath, errorMessage );

        return rulePath;
    }

    public List<RulePath__c> newInstanceWithStatus( List<RulePath__c> rulesPaths, String status ) {
        List<RulePath__c> enrichedRulesPath = new List<RulePath__c>();

        for( RulePath__c rulePath : rulesPaths ) {
            enrichedRulesPath.add( this.newInstance( rulePath.Id ).withStatus( status ) );
        }

        return enrichedRulesPath;
    }
    
    public RulePath__c withStatusAndDataUsedAndExecuteSubRule( String status, String dataUsed, Boolean executeSubRule ) {
        return this.withStatusAndDataUsedAndExecuteSubRule( this.rulePathInstance, status, dataUsed, executeSubRule );
    }

    public RulePath__c withStatusAndDataUsedAndExecuteSubRule( RulePath__c rulePath, String status, String dataUsed, Boolean executeSubRule ) {
        rulePath = this.withStatusAndDataUsed( rulePath, status, dataUsed );
        rulePath = this.withExecuteSubRule( rulePath, executeSubRule );

        return rulePath;
    }

    public RulePath__c withStatusAndDataUsed( String status, String dataUsed ) {
        return this.withStatusAndDataUsed( this.rulePathInstance, status, dataUsed );
    }

    public RulePath__c withStatusAndDataUsed( RulePath__c rulePath, String status, String dataUsed ) {
        rulePath = this.withStatus( rulePath, status );
        rulePath = this.withDataUsed( rulePath, dataUsed );

        return rulePath;
    }

    public List<RulePath__c> withStatus( List<RulePath__c> rulesPaths, String status ) {

        List<RulePath__c> enrichedRulesPaths = new List<RulePath__c>();

        for( RulePath__c rulePath : rulesPaths ) {
            enrichedRulesPaths.add( this.withStatus( rulePath, status ) );
        }

        return enrichedRulesPaths;

    }

    public RulePath__c withStatus( String status ) {
        return this.withStatus( this.rulePathInstance, status );
    } 

    public RulePath__c withStatus( RulePath__c rulePath, String status ) {
        rulePath.Status__c = RulePathPicklistValues.STATUS_BY_CONST.get( status );
        return rulePath;
    }

    public List<RulePath__c> withStatusAPIValue( List<RulePath__c> rulesPaths, String statusAPIValue ) {

        List<RulePath__c> enrichedRulesPaths = new List<RulePath__c>();

        for( RulePath__c rulePath : rulesPaths ) {
            enrichedRulesPaths.add( this.withStatusAPIValue( rulePath, statusAPIValue ) );
        }

        return enrichedRulesPaths;
    }

    public RulePath__c withStatusAPIValue( RulePath__c rulePath, String statusAPIValue ) {
        rulePath.Status__c = statusAPIValue;

        return rulePath;
    }

    public RulePath__c withErrorMessage( RulePath__c rulePath, String errorMessage ) {
        rulePath.ErrorMessage__c = errorMessage;
        return rulePath;
    }

    public List<RulePath__c> withIsDisabled( List<RulePath__c> rulesPaths, Boolean isDisabled ) {

        List<RulePath__c> rulesPathsEnriched = new List<RulePath__c>();

        for( RulePath__c rulePath : rulesPaths ) {
            rulesPathsEnriched.add( this.withIsDisabled( rulePath, isDisabled ) );
        }

        return rulesPathsEnriched;
    }

    public RulePath__c withIsDisabled( RulePath__c rulePath, Boolean isDisabled ) {
        rulePath.isDisabled__c = isDisabled;
        return rulePath;
    }

    public RulePath__c withExecuteSubRule( RulePath__c rulePath, Boolean executeSubRule ) {
        rulePath.ExecuteSubRule__c = executeSubRule;
        return rulePath;
    }

    public RulePath__c withDataUsed( RulePath__c rulePath, String dataUsed ) {
        rulePath.DataUsed__c = dataUsed;

        return rulePath;
    }

    public RulePath__c withStartDate( RulePath__c rulePath, DateTime startDate, String prefix ) {
        rulePath.put( prefix + 'StartDate__c', startDate );
        return rulePath;
    }

    public RulePath__c withEndDateAndSumTimeStamp( RulePath__c rulePath, DateTime endDate, String prefix, BusinessHours defaultBusinessHours ){
        rulePath.put( prefix + 'EndDate__c', endDate );
        rulePath.put(
            prefix + 'Interval__c'
            , BusinessHoursHelper.getInstance().getTimeIntervalMinutes(
                (DateTime) rulePath.get( prefix + 'StartDate__c' )
                , (DateTime) rulePath.get( prefix + 'EndDate__c' )
                , defaultBusinessHours
            )
        );

        return rulePath;
    }

    public RulePath__c withTimeStampErrorMessage( RulePath__c rulePath, String timeStampErrorMessage ) {
        rulePath.IntervalErrorMessage__c = timeStampErrorMessage;
        return rulePath;
    }

}