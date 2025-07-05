/**
 * @description: Class responsible to build SessionIpLogin__c SObject
 * @author: Guilherme Zwipp
 */
public with sharing class SessionIpLoginBuilder {

    private SessionIpLogin__c sessionIpLogin;

    public SessionIpLoginBuilder() {
        this.sessionIpLogin = new SessionIpLogin__c();
    }

    public SessionIpLoginBuilder withSourceIp( String sourceIp ) {
        this.sessionIpLogin.SourceIp__c = sourceIp;
        return this;
    }

    public SessionIpLoginBuilder withUserId( Id userId ) {
        this.sessionIpLogin.User__c = userId;
        return this;
    }

    public SessionIpLoginBuilder withLoginStartDate( DateTime loginStartDate ) {
        this.sessionIpLogin.LoginStartDate__c = loginStartDate;
        return this;
    }

    public SessionIpLoginBuilder withLoginExpirationDate( DateTime loginExpirationDate ) {
        this.sessionIpLogin.LoginExpirationDate__c = loginExpirationDate;
        return this;
    }

    public SessionIpLogin__c build() {
        return this.sessionIpLogin;
    }

}