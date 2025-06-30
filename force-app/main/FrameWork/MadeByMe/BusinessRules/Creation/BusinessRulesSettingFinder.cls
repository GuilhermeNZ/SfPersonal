/**
 * @description: Class responsible to find BusinessRulesSetting by parameters
 * @author: Guilherme Zwipp
 */
public class BusinessRulesSettingFinder{

    private static BusinessRulesSettingFinder instance;

    public static BusinessRulesSettingFinder getInstance() {
        if( instance == null ) instance = new BusinessRulesSettingFinder();
        return instance;
    }

    private BusinessRulesSettingRepository repository;

    private BusinessRulesSettingFinder() {
        this.repository = BusinessRulesSettingRepository.getInstance();
    }

    private static final Integer QUERY_LIMIT = 49999;
    private static final String RULE_KEY_DELIMITER = ';';

    public Map<String,BusinessRulesSetting__c> byRecordsAndSObjectApiNames( List<SObject> sObjectRecords, Set<String> sObjectApiNames ) {
        Map<String,List<BusinessRulesSetting__c>> businessRulesSettingsByObjectName = (Map<String,List<BusinessRulesSetting__c>>) Maps.groupBy(
            'Object__c'
            , this.repository.findByObjectNamesAndIsActivatedAndQueryLimit( sObjectApiNames, true, QUERY_LIMIT )
            , Map<String,List<BusinessRulesSetting__c>>.class
        );

        return this.bySObjectRecordsAndBusinessRulesSettingsByObjectName( sObjectRecords, businessRulesSettingsByObjectName );
    }

    private Map<String,BusinessRulesSetting__c> bySObjectRecordsAndBusinessRulesSettingsByObjectName( List<SObject> sObjectRecords, Map<String,List<BusinessRulesSetting__c>> businessRulesSettingsByObjectName ) {
        Map<String,BusinessRulesSetting__c> businessRulesSettingByObjectId = new Map<String,BusinessRulesSetting__c>();

        for( SObject sObjectRecord : sObjectRecords ) {

            String sObjectApiName = sObjectRecord.getSObjectType().getDescribe().getName();

            if( !businessRulesSettingsByObjectName.containsKey( sObjectApiName ) ) {
                throw new BusinessRulesSettingFinderException( 'No BusinessRulesSetting__c found for SObject type: ' + sObjectApiName );
            }

            BusinessRulesSetting__c matchedSetting = this.findFirstMatchingSetting(
                businessRulesSettingsByObjectName.get( sObjectApiName ), sObjectRecord
            );

            if( matchedSetting == null ) {
                throw new BusinessRulesSettingFinderException( 'No matching BusinessRulesSetting__c found for SObject with Id: ' + sObjectRecord.Id );
            }

            businessRulesSettingByObjectId.put( sObjectRecord.Id, matchedSetting );

        }

        return businessRulesSettingByObjectId;
    }

    private BusinessRulesSetting__c findFirstMatchingSetting( List<BusinessRulesSetting__c> businessRulesSettings, SObject sObjectRecord ) {
        for( BusinessRulesSetting__c businessRulesSetting : businessRulesSettings ) {
            if( this.isRuleKeyMatchingRecord( businessRulesSetting, sObjectRecord ) ) {
                return businessRulesSetting;
            }
        }
        
        return null;
    }

    private Boolean isRuleKeyMatchingRecord( BusinessRulesSetting__c businessRulesSetting, SObject sObjectRecord ){
        if( String.isBlank( businessRulesSetting.RuleKey__c ) ) {
            return false;
        }

        return this.doesRecordMatchKeyValues( businessRulesSetting.RuleKey__c.split( RULE_KEY_DELIMITER ), sObjectRecord );
    }

    private Boolean doesRecordMatchKeyValues( List<String> keyValues, SObject sObjectRecord ) {
        if( keyValues.isEmpty() ) return false;

        for( String keyValue : keyValues ) {

            List<String> keyAndValue = keyValue.replace( ' ','' ).split( '=' );
            if( keyAndValue.size() != 2 ) {
                return false;
            }

            String fieldValue = SObjectHelper.getFieldValue( sObjectRecord, keyAndValue[0] );
            if( String.isBlank( fieldValue ) ) fieldValue = 'null';

            if( !fieldValue.replace( ' ', '' ).equals( keyAndValue[1] ) ) {
                return false;
            }

        }

        return true;
    }

}