/*
 * @description: Service class for Account SObject operations in TriboSession/TestClass files
 * @author Guilherme Zwipp
**/
public with sharing class TCO_AccountService {

    private AccountRepository repository;
    private AccountEnricher enricher;

    public TCO_AccountService() {
        this.repository = AccountRepository.getInstance();
        this.enricher = AccountEnricher.getInstance();
    }

    public List<Account> enrichAccountsDescriptionByTestClassObjects( List<TestClassObject__c> testClassObjects ) {

        Map<String,TestClassObject__c> testClassObjectByAccountId = (Map<String,TestClassObject__c>)
            Maps.indexBy( 'Account__c', testClassObjects );

        List<Account> accounts = this.repository.findByIds( testClassObjectByAccountId.keySet() );

        List<Account> enrichedAccounts = new List<Account>();

        for( Account account : accounts ) {

            if( !testClassObjectByAccountId.containsKey( account.Id ) ) continue;

            enrichedAccounts.add(
                this.enricher.withDescription( account, testClassObjectByAccountId.get( account.Id ).Description__c )
            );
        }

        return this.repository.save( enrichedAccounts );
    }

    @TestVisible
    private void setRepository( AccountRepository repositoryMock ) {
        this.repository = repositoryMock;
    }

}