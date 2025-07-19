/**
 * @description: Enricher class for Account object
 * @author: Guilherme Zwipp
 */
public with sharing class AccountEnricher {

    public static AccountEnricher instance = null;

    public static AccountEnricher getInstance() {
        if( instance == null ) instance = new AccountEnricher();
        return instance;
    }

    public Account withDescription( Account account, String description ) {
        account.Description__c = description;
        return account;
    }

}