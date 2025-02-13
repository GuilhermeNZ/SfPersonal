/**
 * @description: Class to transform CSV Files in Objects
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class CSVConverterToObject {

    public CSVConverterToAccount csvConverterToAccount;

    private ContentDocumentRepository contentDocumentRepository;
    private ContentVersionRepository contentVersionRepository;
    private SObjectRepository SObjectRepository;

    private List<String> csvRecordsListToRemove;
    public Integer count;
    public String errorsInUpsert;

    public CSVConverterToObject() {

        this.csvConverterToAccount = new CSVConverterToAccount();

        this.contentDocumentRepository = new ContentDocumentRepository();
        this.contentVersionRepository = new ContentVersionRepository();
        this.SObjectRepository = new SObjectRepository();

        this.csvRecordsListToRemove = new List<String>();
        this.count = 0;
        this.errorsInUpsert = '';

    }
    
    public List<SObject> convertCSVToRecord( ContentVersion contentVersion ) {

        RowIteratorUtility rowUtility = New RowIteratorUtility( contentVersion.VersionData.toString(),'\n' );

        List<String> csvRecordsList = this.enrichCSVRecordsList( rowUtility );

        this.csvRecordsListToRemove = new List<String>(csvRecordsList);
        
        List<SObject> objectsToUpsert = this.transformCVSColumnsInObjects( csvRecordsList, contentVersion.ObjectType__c, contentVersion.UserEmail__c );

        if( this.count == 0 ) {
            this.completeProcessAndSendEmailToUser( contentVersion );
            return objectsToUpsert;
        }

        Database.UpsertResult[] upsertResult = this.SObjectRepository.upsertAll( objectsToUpsert );

        this.errorsInUpsert += this.getErrorsInObjectUpsert( upsertResult, objectsToUpsert, contentVersion.ObjectType__c );

        if( contentVersion.ErrorsInInsert__c == null ) contentVersion.ErrorsInInsert__c = '';
        this.errorsInUpsert += contentVersion.ErrorsInInsert__c;

        if( this.csvRecordsListToRemove.isEmpty() ) {
            this.completeProcessAndSendEmailToUser( contentVersion );
            return objectsToUpsert;
        }

        this.contentVersionRepository.save( this.createNewVersion( this.csvRecordsListToRemove, contentVersion ) );

        return objectsToUpsert;

    }

    private List<String> enrichCSVRecordsList( RowIteratorUtility rowUtility ) {
        List<String> csvRecordsList = new List<String>();

        while( rowUtility.hasNext() ) {
            csvRecordsList.add( rowUtility.next() );
        }

        return csvRecordsList;
    }

    private List<SObject> transformCVSColumnsInObjects( List<String> csvRecordsList, String objectType, String importUserEmail ) {
        List<SObject> objectsToInsert = new List<SObject>();

        for( String csvRecordList : csvRecordsList ) {
            List<String> columns = csvRecordList.split(';');

            objectsToInsert.addAll( this.transformCVSColumnsInObject( columns, objectType, importUserEmail ) );

            if( this.count >= 500 ) break;

            this.csvRecordsListToRemove.remove(0);

        }

        return this.validateObjectsToUpsert( objectsToInsert, objectType );

    }

    private List<SObject> transformCVSColumnsInObject( List<String> columns, String objectType, String importUserEmail ) {

        List<SObject> objects = new List<SObject>();

        if( objectType == 'Account' ) {
            this.csvConverterToAccount.transformColumnsInSObjects( columns, importUserEmail );
            this.count = this.csvConverterToAccount.getCount();
        }else{
            this.count = 500;
        }

        return objects;

    }

    private List<SObject> validateObjectsToUpsert( List<SObject> objectsToInsert, String objectType ) {

        List<SObject> objects = new List<SObject>();

        if( objectType == 'Account' ) {
            objects.addAll( this.csvConverterToAccount.validateSObjectsToUpsert() );
            this.errorsInUpsert += this.csvConverterToAccount.getErrorsInUpsert();
        }else{
            this.errorsInUpsert = 'Objeto Inválido!';
        }

        return objects;
    }

    private String getErrorsInObjectUpsert( Database.UpsertResult[] upsertResult, List<SObject> objectsToUpsert, String objectType ) {

        if( objectType == 'Account' ) {
            return this.csvConverterToAccount.getAndBuildErrorMessageInSObjectUpsert( upsertResult, objectsToUpsert );
        }

        return '';
    }

    private void completeProcessAndSendEmailToUser( ContentVersion contentVersion ) {

        if( this.errorsInUpsert == '' ) this.errorsInUpsert = 'Importação feita com sucesso!';
            else this.errorsInUpsert = 'Foram encontrados os seguintes erros ao inserir/atualizar seus dados: \n' + this.errorsInUpsert;

        Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] {
                new EmailBuilder()
                .withAddress( contentVersion.UserEmail__c )
                .withSenderDisplayName( 'Salesforce CSV import' )
                .withSubject( 'Processo de importação de cargas completa!' )
                .withPlainTextBody( this.errorsInUpsert )
                .build()
            }
        );

        ContentDocument contentDocument = this.contentDocumentRepository.findById( contentVersion.ContentDocumentId );
        this.contentDocumentRepository.deleteRecord( contentDocument );

    }
    
    private ContentVersion createNewVersion( List<String> csvRecordsListToRemove, ContentVersion contentVersion ) {
        return new ContentVersionBuilder()
            .withVersionData( Blob.valueOf( String.join( csvRecordsListToRemove, '\n') ) )
            .withIsInsert( true )
            .withObjectType( contentVersion.ObjectType__c )
            .withContentDocumentId( contentVersion.ContentDocumentId )
            .withPathOnClient( 'CSVConverterBatch.csv' )
            .withErrorsInInsert( this.errorsInUpsert )
            .withIsExecuting( true )
            .build();
    }

    @TestVisible
    private void setContentDocumentRepository( ContentDocumentRepository contentDocumentRepositoryMock ) {
        this.contentDocumentRepository = contentDocumentRepositoryMock;
    }

    @TestVisible
    private void setContentVersionRepository( ContentVersionRepository contentVersionRepositoryMock ) {
        this.contentVersionRepository = contentVersionRepositoryMock;
    }

    @TestVisible
    private void setSObjectRepository( SObjectRepository SObjectRepositoryMock ) {
        this.SObjectRepository = SObjectRepositoryMock;
    }

}