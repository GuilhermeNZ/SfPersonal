/*
 * @description: Trigger handler for the SObject BusinessRulesSetting__c
 * @author: Guilherme Zwipp
 */
public with sharing class BusinessRulesSettingHandler extends TriggerHandler {

    List<BusinessRulesSetting__c> newBusinessRulesSettings;
    Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById;

    private BusinessRulesSettingFilter filter;

    private RulePathSObjectSettingUpsertService rulePathSObjectSettingUpsertService;

    public BusinessRulesSettingHandler() {
        this.newBusinessRulesSettings = (List<BusinessRulesSetting__c>) Trigger.new;
        this.oldBusinessRulesSettingById = (Map<Id,BusinessRulesSetting__c>) Trigger.oldMap;

        this.filter = new BusinessRulesSettingFilter();

        this.rulePathSObjectSettingUpsertService = new RulePathSObjectSettingUpsertService();
    }

    public override void afterInsert() {
        this.insertOrEnrichRulePathSetting( newBusinessRulesSettings, oldBusinessRulesSettingById );
    }

    public override void afterUpdate() {
        this.insertOrEnrichRulePathSetting( newBusinessRulesSettings, oldBusinessRulesSettingById );
    }

    private void insertOrEnrichRulePathSetting( List<BusinessRulesSetting__c> newBusinessRulesSettings, Map<Id,BusinessRulesSetting__c> oldBusinessRulesSettingById ) {

        List<BusinessRulesSetting__c> businessRulesSettingsWithRuleKeyChanged = this.filter.relevantChangeRecordsFilter(
            newBusinessRulesSettings
            , oldBusinessRulesSettingById
            , 'RuleKey__c'
        );

        if( businessRulesSettingsWithRuleKeyChanged.isEmpty() ) return;

        this.rulePathSObjectSettingUpsertService.byBusinessRulesSettingsRuleKey( businessRulesSettingsWithRuleKeyChanged, oldBusinessRulesSettingById );
    }

}