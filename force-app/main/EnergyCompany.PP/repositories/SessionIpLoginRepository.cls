/**
 * @description: Class to provide stored SessionIpLogin__c collections
 * @author: Guilherme Zwipp
 */
public virtual class SessionIpLoginRepository {

    private static SessionIpLoginRepository instance;

    public static SessionIpLoginRepository getInstance() {
        if (instance == null) instance = new SessionIpLoginRepository();
        return instance;
    }

    protected SessionIpLoginRepository(){}

    public virtual SessionIpLogin__c findBySourceIpAndIsActivated( String sourceIp, Boolean isActivated ) {
        List<SessionIpLogin__c> sessionIpLogins = this.findBySourceIpsAndIsActivated( new List<String>{sourceIp}, isActivated );
        return sessionIpLogins.isEmpty() ? null : sessionIpLogins[0];
    }

    public virtual List<SessionIpLogin__c> findBySourceIpsAndIsActivated( List<String> sourceIps, Boolean isActivated ) {
        return [
            SELECT
                Id
                , SourceIp__c
                , IsActivated__c
            FROM
                SessionIpLogin__c
            WHERE SourceIp__c IN :sourceIps
                AND IsActivated__c = :isActivated
        ];
    }

}