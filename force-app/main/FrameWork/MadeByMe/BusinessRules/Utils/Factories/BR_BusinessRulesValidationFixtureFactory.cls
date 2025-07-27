/**
 * @description: Factory to create BusinessRulesValidation__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public inherited sharing class BR_BusinessRulesValidationFixtureFactory {

    public static BusinessRulesValidation__c createRecord( String name, String className ) {
        return createRecord( buildRecord( name, className ) );
    }
        
    public static BusinessRulesValidation__c buildRecord( String name, String className ) {
        return new BusinessRulesValidation__c(
            Name = name
            , ClassName__c = className
        );
    }

    public static BusinessRulesValidation__c createRecord( BusinessRulesValidation__c businessRulesValidation ) {
        insert businessRulesValidation;
        return businessRulesValidation;
    }

}