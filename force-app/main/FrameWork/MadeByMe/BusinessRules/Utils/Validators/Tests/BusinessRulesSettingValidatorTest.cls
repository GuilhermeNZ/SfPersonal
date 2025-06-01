/**
 * @description: Test class for BusinessRulesSettingValidator
 * @author: Guilherme Zwipp
 */
@isTest
public with sharing class BusinessRulesSettingValidatorTest {

    @isTest
    private static void ruleKeyFieldsIsValid() {

        String businessRulesSettingPayload = '{"Object__c":"BusinessRulesSetting__c"}';

        BusinessRulesSetting__c businessRulesSetting = BusinessRulesSettingFactory.fromJson( businessRulesSettingPayload );

        Map<String,Schema.DescribeSobjectResult> describeSObjectByName = new Map<String,Schema.DescribeSobjectResult>{
            'BusinessRulesSetting__c' => businessRulesSetting.getSObjectType().getDescribe()
        };

        Test.startTest();

        BusinessRulesSettingValidator validator = new BusinessRulesSettingValidator();
        validator.ruleKeyFieldsIsValid( new List<String>{'Name'}, describeSObjectByName, businessRulesSetting );

        Test.stopTest();

        Assert.isFalse( businessRulesSetting.hasErrors(), 'Should dont return field error' );
    }
    
    @isTest
    private static void ruleKeyFieldsIsInvalidError() {

        String businessRulesSettingPayload = '{"Object__c":"BusinessRulesSetting__c"}';

        BusinessRulesSetting__c businessRulesSetting = BusinessRulesSettingFactory.fromJson( businessRulesSettingPayload );

        Map<String,Schema.DescribeSobjectResult> describeSObjectByName = new Map<String,Schema.DescribeSobjectResult>{
            'BusinessRulesSetting__c' => businessRulesSetting.getSObjectType().getDescribe()
        };

        Test.startTest();

        BusinessRulesSettingValidator validator = new BusinessRulesSettingValidator();
        validator.ruleKeyFieldsIsValid( new List<String>{'InvalidField'}, describeSObjectByName, businessRulesSetting );

        Test.stopTest();

        Assert.isTrue( businessRulesSetting.hasErrors(), 'Should return field error' );
        Assert.areEqual( 1, businessRulesSetting.getErrors().size(), 'BusinessRulesSetting__c must contains only one error' );
        Assert.areEqual( Label.BusinessRulesInvalidFields + ' InvalidField', businessRulesSetting.getErrors()[0].getMessage(), 'BusinessRulesSetting__c error message must be: ' + Label.BusinessRulesInvalidFields + ' InvalidField' );
    }

}