/*
* description: This class checks activated SessionIpLogin__c.
* @author: Guilherme Zwipp
*/
public with sharing class PP_SessionIpLoginChecker {

    SessionIpLoginRepository repository;

    public PP_SessionIpLoginChecker() {
        this.repository = SessionIpLoginRepository.getInstance();
    }

    public Boolean currentUserHasSourceIpLoginActivated( String sourceIp ) {
        SessionIpLogin__c sessionIpLogin = this.repository.findBySourceIpAndIsActivated( sourceIp, true );
        if( sessionIpLogin == null ) return false;

        return sessionIpLogin.isActivated__c;
    }

}