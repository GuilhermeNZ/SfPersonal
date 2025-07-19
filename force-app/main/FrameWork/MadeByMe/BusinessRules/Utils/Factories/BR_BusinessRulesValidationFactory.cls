/**
 * @description: Factory to create BusinessRulesValidation__c objects in test context
 * @author: Guilherme Zwipp
 */
public with sharing class BR_BusinessRulesValidationFactory {
    
    public static BusinessRulesValidation__c buildNew( String name, String className ) {
        return new BusinessRulesValidation__c(
            Name = name
            , ClassName__c = className
        );
    }

    public class BR_ExampleValidationRule extends SObjectFactory{

        public BR_ExampleValidationRule( String name ){
            super( buildNew( name, 'BR_ExampleValidationRule' ) );
        }
    }

    public class BR_ExampleTwoValidationRule extends SObjectFactory{

        public BR_ExampleTwoValidationRule( String name ){
            super( buildNew( name, 'BR_ExampleTwoValidationRule' ) );
        }
    }

}