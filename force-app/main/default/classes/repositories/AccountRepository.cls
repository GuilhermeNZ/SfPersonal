public virtual class AccountRepository extends AbstractRepository {

    public static AccountRepository instance = null;

    public static AccountRepository getInstance() {
        if( instance == null ) instance = new AccountRepository();
        return instance;
    }
    
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

    public virtual List<Account> findByIds( Set<String> ids ) {
        return [
            SELECT
                Id
                , Description__c
            FROM
                Account
            WHERE Id IN :ids
        ];
    }

}