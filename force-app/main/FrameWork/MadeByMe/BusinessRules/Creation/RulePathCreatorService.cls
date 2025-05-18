/**
 * @description: Class responsable to create RulesPath__c by parameters
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathCreatorService {

    private static RulePathCreatorService instance = null;

    public static RulePathCreatorService getInstance() {
        if( instance == null ) instance = new RulePathCreatorService();
        return instance;
    }

    public BusinessRulesSettingFinder businessRulesSettingFinderInstance;

    private RulePathCreatorService(){
        this.businessRulesSettingFinderInstance = BusinessRulesSettingFinder.getInstance();
    }

    public List<RulePath__c> byIdAndSObjectApiName( String sObjectId, String sObjectApiName ) {

        //Working: GetSObjetc By Id Dynamic
        SObject sObjectRecord;

        BusinessRulesSetting__c businessRulesSetting = businessRulesSettingFinderInstance.byIdAndSObjectApiName( sObjectRecord, sObjectApiName );

        List<RulePath__c> rulePath = new List<RulePath__c>();

        for( BusinessRulesPath__c businessRulesPath : businessRulesSetting.BusinessRulesPaths__r ) {
            rulePath.add( new RulePathBuilder()
                .withSObjectId( sObjectId )
                .withBusinessRulesPathId( businessRulesPath.Id )
                .withName( businessRulesPath.Name )
                .build()
            );
        }

        return rulePath;
    }
}