/**
 * @description: Fixture Factory to create BusinessRulesPath__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public inherited sharing class BR_BusinessRulesPathFixtureFactory {

    public static BusinessRulesPath__c createRecord( String name, Id businessRulesSettingId, Boolean isActivated, Integer sequence, Id businessRulesValidationId ) {
        return createRecord( buildRecord( name, businessRulesSettingId, isActivated, sequence, businessRulesValidationId ) );
    }
        
    public static BusinessRulesPath__c buildRecord( String name, Id businessRulesSettingId, Boolean isActivated, Integer sequence, Id businessRulesValidationId ) {
        return new BusinessRulesPath__c(
            Name = name
            , BusinessRulesSetting__c = businessRulesSettingId
            , isActivated__c = isActivated
            , Sequence__c = sequence
            , BusinessRulesValidation__c = businessRulesValidationId
        );
    }

    public static BusinessRulesPath__c createRecord( BusinessRulesPath__c businessRulesPath ) {
        insert businessRulesPath;
        return businessRulesPath;
    }

    public static Map<String,SObject> exampleIntegratedScenario( Id businessRulesSettingId, Boolean isActivated, Integer sequence ) {
        Map<String,SObject> records = new Map<String,SObject>();
        
        BusinessRulesValidation__c businessRulesValidation = BR_BusinessRulesValidationFixtureFactory.createRecord(
            'BR_ExampleValidationRule'
            , 'BR_ExampleValidationRule'
        );
        records.put( 'BusinessRulesValidation__c', businessRulesValidation );

        BusinessRulesPath__c businessRulesPath = createRecord(
            'BR_ExampleValidationRule'
            , businessRulesSettingId
            , isActivated
            , sequence
            , businessRulesValidation.Id
        );
        records.put( 'BusinessRulesPath__c', businessRulesPath );

        return records;
    }

    public static Map<String,SObject> exampleTwoIntegratedScenario( Id businessRulesSettingId, Boolean isActivated, Integer sequence ) {
        Map<String,SObject> records = new Map<String,SObject>();
        
        BusinessRulesValidation__c businessRulesValidation = BR_BusinessRulesValidationFixtureFactory.createRecord(
            'BR_ExampleTwoValidationRule'
            , 'BR_ExampleTwoValidationRule'
        );
        records.put( 'BusinessRulesValidation__c', businessRulesValidation );

        BusinessRulesPath__c businessRulesPath = createRecord(
            'BR_ExampleTwoValidationRule'
            , businessRulesSettingId
            , isActivated
            , sequence
            , businessRulesValidation.Id
        );
        records.put( 'BusinessRulesPath__c', businessRulesPath );

        return records;
    }

}