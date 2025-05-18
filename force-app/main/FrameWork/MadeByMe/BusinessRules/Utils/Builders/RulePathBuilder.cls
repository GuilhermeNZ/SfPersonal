/**
 * @description: Class responsible to build RulePath__c SObject
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathBuilder {

    private RulePath__c rulePath;

    public RulePathBuilder() {
        this.rulePath = new RulePath__c();
    }

    public RulePathBuilder withSObjectId( String sObjectId ) {
        this.rulePath.SObjectId__c = sObjectId;

        return this;
    }

    public RulePathBuilder withBusinessRulesPathId( String businessRulesPathId ) {
        this.rulePath.BusinessRulesPath__c = businessRulesPathId;

        return this;
    }

    public RulePathBuilder withName( String name ) {
        this.rulePath.Name = name;

        return this;
    }

    public RulePath__c build() {
        return this.rulePath;
    }

}