/**
 * @description: Class responsible to execute the RulePath and update necessary objects
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathExecuteService {

    private static RulePathExecuteService instance = null;

    public static RulePathExecuteService getInstance() {
        if( instance == null ) instance = new RulePathExecuteService();
        return instance;
    }

    private RulePathRepository repository;
    private RulePathEnricher enricher;

    private RulePathDMLOperations dmlOperations;

    private SObjectRepository sObjectRepositoryInstance;

    private Map<String,Map<String,List<SObject>>> resultsByClassName;
    List<Approval.ProcessSubmitRequest> approvalProcess;

    private RulePathExecuteService() {
        this.repository = RulePathRepository.getInstance();
        this.enricher = RulePathEnricher.getInstance();

        this.dmlOperations = RulePathDMLOperations.getInstance();

        this.sObjectRepositoryInstance = new SObjectRepository();

        this.resultsByClassName = new Map<String,Map<String,List<SObject>>>();
        this.approvalProcess = new List<Approval.ProcessSubmitRequest>();
    }

    public void executeRules( List<RulePath__c> rulesPaths ) {

        try{
            Map<String, List<RulePath__c>> rulesPathsByClassName = (Map<String, List<RulePath__c>>)
            Maps.groupBy( 'ClassName__c', rulesPaths );

            for( String className : rulesPathsByClassName.keySet() ) {
                RulePathAbstract rulePathAbstract = (RulePathAbstract) Type.forName( className ).newInstance();

                Map<String,RulePath__c> rulePathBySObjectId = (Map<String,RulePath__c>)
                    Maps.indexBy( 'SObjectId__c', rulesPathsByClassName.get( className ) );

                rulePathAbstract.executeRule( rulePathBySObjectId );

                this.resultsByClassName.put( className, rulePathAbstract.getSObjectsByName() );
                this.approvalProcess.addAll( rulePathAbstract.getApprovalProcess() );
            }

            this.postExecuteRules( this.approvalProcess, this.resultsByClassName );
        }catch( Exception error ) {
            this.repository.save(
                this.enricher.newInstanceWithStatusAndErrorMessage( rulesPaths, 'ERROR_EXECUTING_RULE', 'Ocorreu um erro ao executar a regra, contate um ADM, Error: ' + error.getMessage() + ' | ' + error.getStackTraceString() )
            );
        }

        
    }

    private void postExecuteRules( List<Approval.ProcessSubmitRequest> approvalProcess, Map<String,Map<String,List<SObject>>> resultsByClassName ) {
        this.dmlOperations.upsertResultsByClassName( resultsByClassName );
        this.dmlOperations.startApprovalProcess( approvalProcess );
    }

    public Map<String,Map<String,List<SObject>>> getResultsByClassName(){
        return this.resultsByClassName;
    }

    public List<Approval.ProcessSubmitRequest> getApprovalProcess(){
        return this.approvalProcess;
    }

}