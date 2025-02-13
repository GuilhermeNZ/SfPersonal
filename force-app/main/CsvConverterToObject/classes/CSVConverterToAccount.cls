public with sharing class CSVConverterToAccount extends CSVConverterToAbstract {

    public CSVConverterToAccount() {
        super( 'Account' );
    }
    
    private AccountRepository accountRepository;

    public override void transformColumnsInSObjects( List<String> columns, String importUserEmail ) {

        this.putUniqueKeyAndUniqueKeyFieldName( columns[1], 'BillingPostalCode' );

        this.putValueByFieldNameBySObjectUniqueKey( columns[0], 'Name' );
        this.putValueByFieldNameBySObjectUniqueKey( columns[1], 'BillingPostalCode' );
        this.putLookupField( columns[2], 'ImportTest1__c', 'ImportTest__c', 'Name' );

    }

    public override List<SObject> validateSObjectsToUpsert() {

        return this.enrichSObjectsToUpsertWithIdAndValueFields();
    }

    public override String getAndBuildErrorMessageInSObjectUpsert( Database.UpsertResult[] upsertResults, List<SObject> SObjects ) {

        String errorMessage = '● Name: FIELD_Name - CEP: FIELD_BillingPostalCode | Error: ERROR_MESSAGE';

        return this.getErrorsInSObjectsUpsert( upsertResults, SObjects, errorMessage );
    }

}