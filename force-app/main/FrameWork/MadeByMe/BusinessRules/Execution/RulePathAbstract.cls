/**
 * @description: Class responsible for performing dependency inversion
 * @author: Guilherme Zwipp
 */
public abstract class RulePathAbstract {

    private RulePathEnricher enricher;
    
    protected Map<String,List<SObject>> sObjectsByName;
    protected List<Approval.ProcessSubmitRequest> approvalProcess;

    public RulePathAbstract() {
        this.enricher = RulePathEnricher.getInstance();

        this.sObjectsByName = new Map<String,List<SObject>>();
        this.approvalProcess = new List<Approval.ProcessSubmitRequest>();
    }

    public virtual Map<String,List<SObject>> executeRule( Map<String,RulePath__c> rulePathBySObjectId ){
        /*
        ---Execution Ordem---
            Queries
            getErrorMessageBySObjectId
            enrichAfterRuleExecution
        OR
            Queries
            executeRuleAndEnrichAfterRuleExecution
        */
        return this.sObjectsByName;
    }

    protected virtual Map<String,String> enrichErrorMessageBySObjectIdMap( Map<String, String> errorMessageBySObjectId, String sObjectId, String errorMessage, String errorTitle ) {

        if( !errorMessageBySObjectId.containsKey( sObjectId ) ) {
            errorMessageBySObjectId.put( sObjectId, errorTitle );
        }

        errorMessageBySObjectId.put( sObjectId, errorMessageBySObjectId.get( sObjectId ) + errorMessage );

        return errorMessageBySObjectId;
    }

    protected Map<String,Map<String,SObject>> initialFilterAndEnrichesSubRules( Map<String,SObject> sObjectById, Map<String,RulePath__c> rulePathBySObjectId ) {

        Map<String,RulePath__c> rulePathWithExecuteSubRulesBySObjectId = new Map<String,RulePath__c>();

        for( String sObjectId : rulePathBySObjectId.keySet() ) {
            RulePath__c rulePath = rulePathBySObjectId.get( sObjectId );

            if( rulePath.ExecuteSubRule__c ) {
                rulePathWithExecuteSubRulesBySObjectId.put( sObjectId, rulePath );
                continue;
            }

            this.enrichSObjectsByName( 'RulePath__c', this.enricher.newInstance( rulePath.Id ).withStatusAndErrorMessage( 'REGRA_ATENDIDA', 'Sub Rule Ignored' ) );
            sObjectById.remove( sObjectId );
        }

        return new Map<String,Map<String,SObject>>{
            'SObject' => sObjectById,
            'RulePath__c' => rulePathWithExecuteSubRulesBySObjectId
        };
    }

    protected void enrichSObjectsByName( String key, SObject value ) {
        this.enrichSObjectsByName( key, new List<SObject>{value} );
    }

    protected void enrichSObjectsByName( String key, List<SObject> values ) {
        if( values.isEmpty() ) return;

        if( !this.sObjectsByName.containsKey( key ) ) this.sObjectsByName.put( key, new List<SObject>() );
        this.sObjectsByName.get( key ).addAll( values );
    }

    public Map<String,List<SObject>> getSObjectsByName(){
        return this.sObjectsByName;
    }

    public List<Approval.ProcessSubmitRequest> getApprovalProcess(){
        return this.approvalProcess;
    }

}