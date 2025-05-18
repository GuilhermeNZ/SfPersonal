/**
 * @description: Class responsible for performing dependency inversion
 * @author: Guilherme Zwipp
 */
public abstract class RulePathAfterExecutionAbstract {

    protected Map<String,List<SObject>> sObjectsByName;
    protected List<Approval.ProcessSubmitRequest> approvalProcess;

    public RulePathAfterExecutionAbstract(){
        this.sObjectsByName = new Map<String,List<SObject>>();
        this.approvalProcess = new List<Approval.ProcessSubmitRequest>();
    }
    
    public virtual Map<String,List<SObject>> execute( List<RulePath__c> reprovedRulesPaths ) {
        return this.sObjectsByName;
    }

    public Map<String,List<SObject>> getSObjectsByName(){
        return this.sObjectsByName;
    }

    public List<Approval.ProcessSubmitRequest> getApprovalProcess(){
        return this.approvalProcess;
    }

}