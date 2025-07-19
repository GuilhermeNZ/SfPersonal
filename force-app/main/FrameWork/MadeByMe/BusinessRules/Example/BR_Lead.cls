/**
 * @description: Example class using BusinessRulesSetting framework
 * @author: Guilherme Zwipp
 */
public with sharing class BR_Lead {
    
    private static RulePathCreatorService rulePathCreatorServiceInstance;
    
    static{
        rulePathCreatorServiceInstance = RulePathCreatorService.getInstance();
    }
    
    public static void createRulesPath( Lead lead ) {
        rulePathCreatorServiceInstance.bySObjectIdCreate( lead.Id );
    }

}