/**
 * @description: Class responsable to find BusinessRulesSetting by parameters
 * @author: Guilherme Zwipp
 */
public class BusinessRulesSettingFinder{

    private static BusinessRulesSettingFinder instance = null;

    public static BusinessRulesSettingFinder getInstance() {
        if( instance == null ) instance = new BusinessRulesSettingFinder();
        return instance;
    }

    private BusinessRulesSettingRepository repository;

    private BusinessRulesSettingFinder() {
        this.repository = BusinessRulesSettingRepository.getInstance();
    }

    // public Map<BusinessRulesSetting__c,List<Quote>> byQuotes( List<Quote> quotes ) {

    //     Map<BusinessRulesSetting__c,List<Quote>> quotesByBusinessRulesSettings = new Map<BusinessRulesSetting__c,List<Quote>>();

    //     List<BusinessRulesSetting__c> businessRulesSettings = this.repository.findByIsActivatedAndObjectWithPatchsOrderByCreatedDateDESCLimit49999( 'Quote' ); //[SELECT Id, KeyValue__c, (SELECT Id, BusinessRulesValidation__r.ClassName__c, BusinessRulesValidation__r.FieldName__c FROM BusinessRulesPaths__r AND Active__c = true ORDER BY Priority__c ASC) FROM BusinessRulesSettings__c WHERE Active__c = True ORDER BY CreatedDate DESC];

    //     for( Quote quote : quotes ) {
    //         BusinessRulesSetting__c businessRulesSetting = this.byQuote( quote, businessRulesSettings );

    //         if( businessRulesSetting == null ) continue;

    //         if( !quotesByBusinessRulesSettings.containsKey( businessRulesSetting ) ) quotesByBusinessRulesSettings.put( businessRulesSetting, new List<Quote>() );
    //         quotesByBusinessRulesSettings.get( businessRulesSetting ).add( quote );
    //     }

    //     return quotesByBusinessRulesSettings;
    // }

    public BusinessRulesSetting__c byIdAndSObjectApiName( SObject sObjectRecord, String sObjectApiName ) {

        List<BusinessRulesSetting__c> businessRulesSettings = this.repository.findByIsActivatedAndObjectWithPatchsOrderByCreatedDateDESCLimit49999( 'Quote' );

        return this.byQuote( sObjectRecord, businessRulesSettings );
    }

    public BusinessRulesSetting__c byQuote( SObject sObjectRecord, List<BusinessRulesSetting__c> businessRulesSettings ) {

        for( BusinessRulesSetting__c businessRulesSetting : businessRulesSettings ) {

            Boolean settingFound = true;

            List<String> keyValues = businessRulesSetting.RuleKey__c.split(';');

            if( keyValues.isEmpty() ) continue;

            for( String keyValue : keyValues ) {

                List<String> keyAndValue = keyValue.replace(' ','').split('=');
    
                if( this.getFieldValue( sObjectRecord, keyAndValue[0] ).replace( ' ', '' ) != keyAndValue[1] ) {
                    settingFound = false;
                    break;
                }

            }

            if( !settingFound ) continue;

            return businessRulesSetting;

        }

        return new BusinessRulesSetting__c();

    }

    private String getFieldValue( SObject record, String field ) {
        List<String> splitedField = field.split('\\.');
        for ( Integer i = 0; i < splitedField.size(); i++ ) {
            if( i == splitedField.size() - 1 ) {
                return String.valueOf( record.get( splitedField[i] ) );
            }
            record = record.getSObject( splitedField[i] );
            if( record == null ) return null;
        }
        return '';
    }

    @TestVisible
    private void setBusinessRulesSettingRepository( BusinessRulesSettingRepository repositoryMock ) {
        this.repository = repositoryMock;
    }

}