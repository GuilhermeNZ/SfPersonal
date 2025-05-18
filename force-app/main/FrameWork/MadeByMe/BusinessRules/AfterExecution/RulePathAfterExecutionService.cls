/**
 * @description: Class responsable to execute the afterExecution rule by className
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathAfterExecutionService {

    private static RulePathAfterExecutionService instance = null;

    public static RulePathAfterExecutionService getInstance(){
        if( instance == null ) instance = new RulePathAfterExecutionService();
        return instance;
    }

    RulePathDMLOperations dmlOperations;

    private Map<String,Map<String,List<SObject>>> resultsByClassName;
    List<Approval.ProcessSubmitRequest> approvalProcess;

    public RulePathAfterExecutionService(){
        this.dmlOperations = RulePathDMLOperations.getInstance();

        this.resultsByClassName = new Map<String,Map<String,List<SObject>>>();
        this.approvalProcess = new List<Approval.ProcessSubmitRequest>();
    }

    //Working
    private final Map<String,String> CLASSNAME_BY_AFTER_EXECUTION_CLASSNAME = new Map<String,String>{
        'SupplierValidationRule' => 'SupplierAfterExecutionRule',
        'ProductHasStockValidationRule' => 'ProductHasStockAfterExecutionRule'
    };
    
    public void reprovedActions( List<RulePath__c> reprovedRulesPaths ) {

        Map<String,List<RulePath__c>> reprovedQuoteRulesPathsByClassName = (Map<String,List<RulePath__c>>)
            Maps.groupBy( 'ClassName__c', reprovedRulesPaths );

        for( String className : reprovedQuoteRulesPathsByClassName.keySet() ) {
            if( !this.CLASSNAME_BY_AFTER_EXECUTION_CLASSNAME.containsKey( className ) ) continue;

            RulePathAfterExecutionAbstract afterExecutionAbstract = (RulePathAfterExecutionAbstract) 
                Type.forName( this.CLASSNAME_BY_AFTER_EXECUTION_CLASSNAME.get( className ) ).newInstance();

            afterExecutionAbstract.execute( reprovedQuoteRulesPathsByClassName.get( className ) );

            this.resultsByClassName.put( className, afterExecutionAbstract.getSObjectsByName() );
            this.approvalProcess.addAll( afterExecutionAbstract.getApprovalProcess() );
        }
        
        this.postExecuteRules( this.resultsByClassName, this.approvalProcess );
    }

    private void postExecuteRules( Map<String,Map<String,List<SObject>>> resultsByClassName, List<Approval.ProcessSubmitRequest> approvalProcess ) {
        this.dmlOperations.upsertResultsByClassName( resultsByClassName );
        this.dmlOperations.startApprovalProcess( approvalProcess );
    }

}