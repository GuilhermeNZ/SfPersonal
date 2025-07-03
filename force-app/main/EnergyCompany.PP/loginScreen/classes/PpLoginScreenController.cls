/**
 * @description: Class to controller apex operation in ppLoginScreen lwc
 * @author: Guilherme Zwipp
 */
public with sharing class PpLoginScreenController {
    private static PP_SessionIpLoginChecker pp_SessionIpLoginCheckerInstance;

    static{
        pp_SessionIpLoginCheckerInstance = new PP_SessionIpLoginChecker();
    }
    
    @AuraEnabled
    public static Boolean currentUserHasAutomaticLogin(){
        return pp_SessionIpLoginCheckerInstance.currentUserHasSourceIpLoginActivated( Auth.SessionManagement.getCurrentSession().get( 'SourceIp' ) );
    }

}