/**
 * @description: Trigger handler for the SObject TestClassObject__c
 * @author: Guilherme Zwipp
 */
public with sharing class TestClassObjectHandler extends TriggerHandler {

    private List<TestClassObject__c> tNew;

    private TestClassObjectFilter filter;

    private TCO_AccountService accountService;

    public TestClassObjectHandler() {
        this.tNew = Trigger.new;

        this.filter = TestClassObjectFilter.getInstance();

        this.accountService = new TCO_AccountService();
    }

    public override void afterInsert() {
        this.enrichAccountDescription( this.tNew );
    }

    private void enrichAccountDescription( List<TestClassObject__c> newTestClassObjects ) {

        List<TestClassObject__c> filteredTestClassObjects = this.filter.filterByNotEmptyValue( newTestClassObjects, 'Description__c' );

        if( filteredTestClassObjects.isEmpty() ) return;

        this.accountService.enrichAccountsDescriptionByTestClassObjects( filteredTestClassObjects );
    }
}