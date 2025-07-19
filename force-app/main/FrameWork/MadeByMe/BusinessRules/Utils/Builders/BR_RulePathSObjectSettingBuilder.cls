/**
 * @description: Class responsible to build RulePathSObjectSetting__c SObject
 * @author: Guilherme Zwipp
 */
public with sharing class BR_RulePathSObjectSettingBuilder {

    private RulePathSObjectSetting__c rulePathSObjectSetting;

    public BR_RulePathSObjectSettingBuilder() {
        rulePathSObjectSetting = new RulePathSObjectSetting__c();
    }

    public BR_RulePathSObjectSettingBuilder withObjectAPIName( String objectAPIName ) {
        this.rulePathSObjectSetting.ObjectAPIName__c = objectAPIName;
        return this;
    }

    public RulePathSObjectSetting__c build(){
        return this.rulePathSObjectSetting;
    }

}