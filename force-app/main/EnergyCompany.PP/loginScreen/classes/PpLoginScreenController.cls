/**
 * @description: Class to controller apex operation in ppLoginScreen lwc
 * @author: Guilherme Zwipp
 */
public with sharing class PpLoginScreenController {
    private static PP_SessionIpLoginChecker pp_SessionIpLoginCheckerInstance;
    private static PP_SessionIpLoginCreator pp_SessionIpLoginCreatorInstance;

    static{
        pp_SessionIpLoginCheckerInstance = new PP_SessionIpLoginChecker();
        pp_SessionIpLoginCreatorInstance = new PP_SessionIpLoginCreator();
    }
    
    @AuraEnabled
    public static Boolean currentUserHasAutomaticLogin(){
        return pp_SessionIpLoginCheckerInstance.currentUserHasSourceIpLoginActivated( Auth.SessionManagement.getCurrentSession().get( 'SourceIp' ) );
    }

    @AuraEnabled
    public static SessionIpLogin__c createNewSourceIpSession(){
        return pp_SessionIpLoginCreatorInstance.byUserSourceIpAndUserIdAndLoginStartDateAndProfileId(
            Auth.SessionManagement.getCurrentSession().get( 'SourceIp' )
            , UserInfo.getUserId()
            , DateTime.now()
            , UserInfo.getProfileId()
        );
    }

}