public with sharing class AccountBuilder {
    
    private Account account;

    public AccountBuilder() {
        this.account = new Account();
    }

    public AccountBuilder withName( String name ) {
        this.account.Name = name;

        return this;
    }

    public AccountBuilder withBillingPostalCode( String billingPostalCode ) {
        this.account.BillingPostalCode = billingPostalCode;

        return this;
    }

    public Account build() {
        return this.account;
    }

}