/**
 * @description: Class responsible to build RulePathSObjectSetting__c SObject
 * @author: Guilherme Zwipp
 */
public with sharing class BR_RulePathSObjectSettingBuilder {

    private RulePathSObjectSetting__c rulePathSObjectSetting;

    public BR_RulePathSObjectSettingBuilder() {
        rulePathSObjectSetting = new RulePathSObjectSetting__c();
    }

    public BR_RulePathSObjectSettingBuilder withName( String name ) {
        this.rulePathSObjectSetting.Name = name;
        return this;
    }

    public BR_RulePathSObjectSettingBuilder withFieldsToUseInQuery( String fieldsToUseInQuery ) {
        this.rulePathSObjectSetting.FieldsToUseInQuery__c = fieldsToUseInQuery;
        return this;
    }

    public RulePathSObjectSetting__c build(){
        return this.rulePathSObjectSetting;
    }

}