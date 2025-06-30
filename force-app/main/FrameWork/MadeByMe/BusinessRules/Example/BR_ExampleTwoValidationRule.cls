/**
 * @description: Example validation rule to be used in test context
 * @author: Guilherme Zwipp
 */
public with sharing class BR_ExampleTwoValidationRule extends RulePathAbstract {
    public override Map<String,List<SObject>> executeRule( Map<String,RulePath__c> rulePathBySObjectId ){
        return new Map<String,List<SObject>>();
    }
}