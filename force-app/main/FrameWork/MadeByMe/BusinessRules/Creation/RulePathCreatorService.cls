/**
 * @description: Class responsible for creating RulePath__c records based on parameters
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathCreatorService {

    private SObjectRepository sObjectRepository;
    private RulePathSObjectSettingRepository rulePathSObjectSettingRepositoryInstance;

    private BusinessRulesSettingFinder businessRulesSettingFinderInstance;

    public RulePathCreatorService(){
        this.businessRulesSettingFinderInstance = BusinessRulesSettingFinder.getInstance();
        this.rulePathSObjectSettingRepositoryInstance = RulePathSObjectSettingRepository.getInstance();

        this.sObjectRepository = new SObjectRepository();
    }

    public List<RulePath__c> bySObjectIdCreate( Id sObjectId ) {
        return this.sObjectRepository.save( this.bySObjectIdBuild( sObjectId ) );
    }

    public List<RulePath__c> bySObjectIdsCreate( List<Id> sObjectIds ) {
        return this.sObjectRepository.save( this.bySObjectIdsBuild( sObjectIds ) );
    }

    public List<RulePath__c> bySObjectIdBuild( Id sObjectId ) {
        return this.bySObjectIdsBuild( new List<Id>{sObjectId} );
    }

    public List<RulePath__c> bySObjectIdsBuild( List<Id> sObjectIds ) {

        Map<String,List<Id>> idsBySObjectApiName = IdHelper.buildMapIdsBySObjectApiName( sObjectIds );

        Map<String,RulePathSObjectSetting__c> rulePathSObjectSettingBySObjectName = (Map<String,RulePathSObjectSetting__c>) Maps.indexBy(
            'ObjectAPIName__c'
            , this.rulePathSObjectSettingRepositoryInstance.findByObjectAPINames( idsBySObjectApiName.keySet() )
            , Map<String,RulePathSObjectSetting__c>.class
        );

        Map<String,BusinessRulesSetting__c> businessRulesSettingByObjectId = this.businessRulesSettingFinderInstance.byRecordsAndSObjectApiNames(
            this.findSObjectsToCreateRulePaths( idsBySObjectApiName, rulePathSObjectSettingBySObjectName )
            , idsBySObjectApiName.keySet()
        );

        return this.buildRulePaths( businessRulesSettingByObjectId );

    }

    private List<SObject> findSObjectsToCreateRulePaths( Map<String,List<Id>> idsBySObjectApiName, Map<String,RulePathSObjectSetting__c> rulePathSObjectSettingBySObjectName ) {
        List<SObject> sObjectRecords = new List<SObject>();

        for( String sObjectApiName : idsBySObjectApiName.keySet() ) {

            if( !rulePathSObjectSettingBySObjectName.containsKey( sObjectApiName ) ) {
                throw new RulePathCreatorServiceException( 'RulePathSObjectSetting__c not found to SObject: ' + sObjectApiName );
            }

            if( rulePathSObjectSettingBySObjectName.get( sObjectApiName ).RulePathFieldsSettings__r.isEmpty() ) {
                throw new RulePathCreatorServiceException( 'RulePathSObjectSetting__c for SObject: ' + sObjectApiName + ' is missing Field to Query' );
            }

            sObjectRecords.addAll(
                this.sObjectRepository.buildAndFindByIds(
                    new Set<String>( Lists.byField( rulePathSObjectSettingBySObjectName.get( sObjectApiName ).RulePathFieldsSettings__r, 'Name' ) )
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