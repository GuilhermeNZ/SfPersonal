/**
 * @description: Factory to create BusinessRulesPath__c objects in test context
 * @author: Guilherme Zwipp
 */
public with sharing class BR_BusinessRulesPathFactory {
    
    public static BusinessRulesPath__c buildNew( String name, Id businessRulesSettingId, Boolean isActivated, Integer sequence, Id businessRulesValidationId ) {
        return new BusinessRulesPath__c(
            Name = name
            , BusinessRulesSetting__c = businessRulesSettingId
            , isActivated__c = isActivated
            , Sequence__c = sequence
            , BusinessRulesValidation__c = businessRulesValidationId
        );
    }

    public class BR_ExampleValidationRule extends SObjectFactory{

        public BR_ExampleValidationRule( Id businessRulesSettingId, Boolean isActivated, Integer sequence ){
            super(
                buildNew(
                    'BR_ExampleValidationRule'
                    , businessRulesSettingId
                    , isActivated
                    , sequence
                    , new BR_BusinessRulesValidationFactory.BR_ExampleValidationRule( 'BR_ExampleValidationRule' ).createRecord().Id
                )
            );
        }
    }

    public class BR_ExampleTwoValidationRule extends SObjectFactory{

        public BR_ExampleTwoValidationRule( Id businessRulesSettingId, Boolean isActivated, Integer sequence ){
            super(
                buildNew(
                    'BR_ExampleTwoValidationRule'
                    , businessRulesSettingId
                    , isActivated
                    , sequence
                    , new BR_BusinessRulesValidationFactory.BR_ExampleTwoValidationRule( 'BR_ExampleTwoValidationRule' ).createRecord().Id
                )
            );
        }
    }

}