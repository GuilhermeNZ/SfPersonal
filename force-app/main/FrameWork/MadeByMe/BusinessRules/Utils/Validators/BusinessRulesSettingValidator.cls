/**
 * @description: Class to validate BusinessRulesSetting__c with criterias
 * @author: Guilherme Zwipp
 */
public with sharing class BusinessRulesSettingValidator {

    private static BusinessRulesSettingValidator instance;

    public static BusinessRulesSettingValidator getInstance() {
        if( instance == null ) instance = new BusinessRulesSettingValidator();
        return instance;
    }

    private BusinessRulesSettingValidator(){}

    public void ruleKeyFieldsIsValid( List<String> ruleKeyFields, Map<String,Schema.DescribeSobjectResult> describeSObjectByName, BusinessRulesSetting__c businessRulesSetting ) {

        Map<String,Schema.SObjectField> fieldByName = describeSObjectByName.get( businessRulesSetting.Object__c ).fields.getMap();

        List<String> invalidFields = new List<String>();

        for( String fieldToAddInQuery : ruleKeyFields ) {
            //Working, added relationship field validation too
            if( fieldToAddInQuery.contains( '__r' ) ) continue;
            if( fieldByName.containsKey( fieldToAddInQuery ) ) continue;
            invalidFields.add( fieldToAddInQuery );
        }

        if( invalidFields.isEmpty() ) return;

        businessRulesSetting.addError( Label.BusinessRulesInvalidFields + ' ' + String.join( invalidFields, ',' ) );
    }

}