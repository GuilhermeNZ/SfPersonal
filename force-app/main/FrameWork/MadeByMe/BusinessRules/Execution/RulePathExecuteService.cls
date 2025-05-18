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
    
    //Working
    public void executeRules( List<RulePath__c> rulesPaths ) {

        try{
            Map<String, List<RulePath__c>> rulesPathsByClassName = (Map<String, List<RulePath__c>>)
            Maps.groupBy( 'ClassName__c', rulesPaths );
    
            List<SObject> sObjects = this.sObjectRepositoryInstance.findByIdsToUseInRulesExecution( Lists.byField( rulesPaths, 'SObjectId__c' ) );
            Map<String,SObject> sObjectById = new Map<String,SObject>( sObjects );

            for( String className : rulesPathsByClassName.keySet() ) {
                RulePathAbstract rulePathAbstract = (RulePathAbstract) Type.forName( className ).newInstance();

                Map<String,RulePath__c> rulePathBySObjectId = (Map<String,RulePath__c>)
                    Maps.indexBy( 'SObjectId__c', rulesPathsByClassName.get( className ) );

                Map<String,SObject> filteredSObjects = this.provideSObjects( sObjectById, rulesPathsByClassName.get( className ) );

                rulePathAbstract.executeRule( filteredSObjects, rulePathBySObjectId );
                
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

    private Map<String,SObject> provideSObjects( Map<String,SObject> sObjectById, List<RulePath__c> rulesPathsToExecute ) {

        Map<String,SObject> filteredSObjects = new Map<String,SObject>();

        for( RulePath__c rulePathToExecute : rulesPathsToExecute ){
            if( filteredSObjects.containsKey( rulePathToExecute.SObjectId__c ) ) continue;
            filteredSObjects.put( rulePathToExecute.SObjectId__c, sObjectById.get( rulePathToExecute.SObjectId__c ) );
        }

        return filteredSObjects;
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