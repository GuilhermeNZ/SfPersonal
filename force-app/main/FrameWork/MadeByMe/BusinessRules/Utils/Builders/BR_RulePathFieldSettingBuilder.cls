/**
 * @description: Class responsible to build RulePathFieldSetting__c SObject
 * @author: Guilherme Zwipp
 */
public with sharing class BR_RulePathFieldSettingBuilder {

    private RulePathFieldSetting__c rulePathFieldSetting;

    public BR_RulePathFieldSettingBuilder() {
        this.rulePathFieldSetting = new RulePathFieldSetting__c();
    }

    public BR_RulePathFieldSettingBuilder withName( String name ) {
        this.rulePathFieldSetting.Name = name;
        return this;
    }

    public BR_RulePathFieldSettingBuilder withRelatedSObjectAPIName( String objectApiName ) {
        this.rulePathFieldSetting.RulePathSObjectSetting__r = new RulePathSObjectSetting__c( ObjectAPIName__c = objectApiName );
        return this;
    }

    public RulePathFieldSetting__c build() {
        return this.rulePathFieldSetting;
    }

}