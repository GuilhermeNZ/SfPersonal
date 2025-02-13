public with sharing class AccountRepository {
    
    public List<Account> findByBillingPostalCodes( Set<String> billingPostalCodes ) {
        return [
            SELECT
                Id
                , BillingPostalCode
            FROM
                Account
            WHERE BillingPostalCode IN :billingPostalCodes
        ];
    }

}