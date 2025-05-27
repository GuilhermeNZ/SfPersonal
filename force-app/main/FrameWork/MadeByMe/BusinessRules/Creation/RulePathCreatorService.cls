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

    private SObjectRepository sObjectRepository;
    private RulePathSObjectSettingRepository rulePathSObjectSettingRepositoryInstance;

    private BusinessRulesSettingFinder businessRulesSettingFinderInstance;

    private RulePathCreatorService(){
        this.businessRulesSettingFinderInstance = BusinessRulesSettingFinder.getInstance();
        this.rulePathSObjectSettingRepositoryInstance = RulePathSObjectSettingRepository.getInstance();

        this.sObjectRepository = new SObjectRepository();
    }

    public List<RulePath__c> byIdAndSObjectApiName( String sObjectId, String sObjectApiName ) {

        RulePathSObjectSetting__c rulePathSObjectSetting = this.rulePathSObjectSettingRepositoryInstance.findByName( sObjectApiName );

        //Working, thown exception when dont return rulePathSObjectSetting

        SObject sObjectRecord = this.sObjectRepository.buildAndFindById(
            rulePathSObjectSetting.FieldsToUseInQuery__c.split( ',' )
            , sObjectApiName
            , sObjectId
        );

        BusinessRulesSetting__c businessRulesSetting = this.businessRulesSettingFinderInstance.byIdAndSObjectApiName( sObjectRecord, sObjectApiName );

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