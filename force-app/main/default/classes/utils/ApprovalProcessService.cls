/*
 * @description: Service class for ApprovalProcess SObject operations
 * @author Guilherme Zwipp
**/
public with sharing class ApprovalProcessService {

    private static ApprovalProcessService instance = null;

    public static ApprovalProcessService getInstance(){
        if( instance == null ) instance = new ApprovalProcessService();
        return instance;
    }

    private ApprovalProcessService(){}
    
    public virtual void process( List<Approval.ProcessSubmitRequest> approvalsProcess ) {
        Approval.process( approvalsProcess );
    }

}