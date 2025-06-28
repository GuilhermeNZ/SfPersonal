/**
 * @description: Class responsible for creating RulePath__c records based on parameters
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

    public List<RulePath__c> bySObjectIdCreate( Id sObjectId ) {
        return this.sObjectRepository.save( this.bySObjectIdBuild( sObjectId ) );
    }

    public List<RulePath__c> bySObjectIdBuild( Id sObjectId ) {
        return this.bySObjectIdsBuild( new List<Id>{sObjectId} );
    }

    public List<RulePath__c> bySObjectIdsBuild( List<Id> sObjectIds ) {

        Map<String,List<Id>> idsBySObjectApiName = IdHelper.buildMapIdsBySObjectApiName( sObjectIds );

        List<RulePathSObjectSetting__c> rulePathSObjectSettings = this.rulePathSObjectSettingRepositoryInstance.findByNames( idsBySObjectApiName.keySet() );

        Map<String,RulePathSObjectSetting__c> rulePathSObjectSettingBySObjectName = rulePathSObjectSettings.isEmpty() ? new Map<String,RulePathSObjectSetting__c>()
            : (Map<String,RulePathSObjectSetting__c>) Maps.indexBy( 'Name', rulePathSObjectSettings );

        List<SObject> sObjectRecords = this.findSObjectsToCreateRulePaths( idsBySObjectApiName, rulePathSObjectSettingBySObjectName );

        Map<String,BusinessRulesSetting__c> businessRulesSettingByObjectId = this.businessRulesSettingFinderInstance.byRecordsAndSObjectApiNames( sObjectRecords, idsBySObjectApiName.keySet() );

        return this.buildRulePaths( businessRulesSettingByObjectId );

    }

    private List<SObject> findSObjectsToCreateRulePaths( Map<String,List<Id>> idsBySObjectApiName, Map<String,RulePathSObjectSetting__c> rulePathSObjectSettingBySObjectName ) {
        List<SObject> sObjectRecords = new List<SObject>();

        for( String sObjectApiName : idsBySObjectApiName.keySet() ) {

            if( !rulePathSObjectSettingBySObjectName.containsKey( sObjectApiName ) ) {
                throw new RulePathCreatorServiceException( 'RulePathSObjectSetting__c not found to SObject: ' + sObjectApiName );
            }

            if( String.isBlank( rulePathSObjectSettingBySObjectName.get( sObjectApiName ).FieldsToUseInQuery__c ) ) {
                throw new RulePathCreatorServiceException( 'RulePathSObjectSetting__c for SObject: ' + sObjectApiName + ' is missing FieldsToUseInQuery__c' );
            }

            sObjectRecords.addAll(
                this.sObjectRepository.buildAndFindByIds(
                    rulePathSObjectSettingBySObjectName.get( sObjectApiName ).FieldsToUseInQuery__c.split( ',' )
                    , sObjectApiName
                    , idsBySObjectApiName.get( sObjectApiName )
                )
            );
        }

        return sObjectRecords;
    }

    private List<RulePath__c> buildRulePaths( Map<String,BusinessRulesSetting__c> businessRulesSettingByObjectId ) {

        List<RulePath__c> rulePaths = new List<RulePath__c>();

        for( String sObjectId : businessRulesSettingByObjectId.keySet() ) {

            for( BusinessRulesPath__c businessRulesPath : businessRulesSettingByObjectId.get( sObjectId ).BusinessRulesPaths__r ) {
                rulePaths.add( new RulePathBuilder()
                    .withSObjectId( sObjectId )
                    .withBusinessRulesPathId( businessRulesPath.Id )
                    .withName( businessRulesPath.Name )
                    .build()
                );
            }

        }

        return rulePaths;
    }

}