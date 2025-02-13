public with sharing class AccountDAO {
    public Account getAccountById(Id accountId){
       return [SELECT Id, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, BillingNumber__c FROM Account WHERE Id = :accountId];
    }

    public Account getAccountByCEP(String cep){
        Account account = [SELECT Id, Name, BillingPostalCode FROM Account WHERE BillingPostalCode = :cep];

        return account;
    }
}