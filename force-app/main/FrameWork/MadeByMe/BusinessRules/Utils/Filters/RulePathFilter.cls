/**
 * @description: Class to filter RulePath__c collections
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathFilter extends Filter {
        
    private static RulePathFilter instance = null;

    public static RulePathFilter getInstance(){
        if( instance == null ) instance = new RulePathFilter();
        return instance;
    }

    Decimal highestRuleSequence = 0;

    private RulePathFilter(){}

    public List<RulePath__c> byFirstSequence( List<RulePath__c> rulesPaths ) {

        Map<String,Map<Decimal,List<RulePath__c>>> activatedRulesPathsBySequenceBySObjectId = this.bySequenceBySObjectId( rulesPaths );

        List<RulePath__c> firstRulePath = new List<RulePath__c>();

        for( Map<Decimal,List<RulePath__c>> rulesPathsBySequence : activatedRulesPathsBySequenceBySObjectId.values() ) {

            for ( Decimal ruleSequence = 1; ruleSequence <= this.highestRuleSequence; ruleSequence++ ) {
                if( !rulesPathsBySequence.containsKey( ruleSequence ) ) continue;

                firstRulePath.addAll( rulesPathsBySequence.get( ruleSequence ) );
                break;
            }

        }

        return firstRulePath;

    }

    public Map<String,Map<Decimal,List<RulePath__c>>> bySequenceBySObjectId( List<RulePath__c> rulesPaths ) {
        Map<String,Map<Decimal,List<RulePath__c>>> activatedRulesPathsBySequenceBySObjectId = new Map<String,Map<Decimal,List<RulePath__c>>>();

        for( RulePath__c rulePath : rulesPaths ) {

            if( !rulePath.isActivated__c || rulePath.Sequence__c == null ) continue;

            String sObjectId = rulePath.SObjectId__c;

            if( !activatedRulesPathsBySequenceBySObjectId.containsKey( sObjectId ) ) {
                activatedRulesPathsBySequenceBySObjectId.put( sObjectId, new Map<Decimal,List<RulePath__c>>() );
            }

            if( !activatedRulesPathsBySequenceBySObjectId.get( sObjectId ).containsKey( rulePath.Sequence__c ) ) {
                activatedRulesPathsBySequenceBySObjectId.get( sObjectId ).put( rulePath.Sequence__c, new List<RulePath__c>() );
            }

            activatedRulesPathsBySequenceBySObjectId.get( sObjectId ).get( rulePath.Sequence__c ).add( rulePath );

            if( this.highestRuleSequence < rulePath.Sequence__c ) this.highestRuleSequence = rulePath.Sequence__c;

        }

        return activatedRulesPathsBySequenceBySObjectId;
    }

    public List<RulePath__c> byStatus( List<RulePath__c> rulesPaths, String status ) {
        
        List<RulePath__c> filteredRulesPaths = new List<RulePath__c>();

        for( RulePath__c rulePath : rulesPaths ) {
            if( rulePath.Status__c != RulePathPicklistValues.STATUS_BY_CONST.get( status ) ) continue;

            filteredRulesPaths.add( rulePath );
        }

        return filteredRulesPaths;
    }

}