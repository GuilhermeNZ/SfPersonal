/**
 * @description: Batch for processing CSVConverterToObject processes
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class CSVConverterToObjectBatch implements Schedulable, Database.Batchable<SObject> {

    CSVConverterToObject CSVConverterToObject;

    ContentDocumentRepository contentDocumentRepository;
    ContentVersionRepository contentVersionRepository;

    public CSVConverterToObjectBatch() {
        CSVConverterToObject = new CSVConverterToObject();

        this.contentDocumentRepository = new ContentDocumentRepository();
        this.contentVersionRepository = new ContentVersionRepository();
    }

    public void execute(SchedulableContext context) {
        Database.executeBatch(this);
    }

    public void execute(Database.BatchableContext context, List<SObject> records) {
        ContentVersion contentVersion = (ContentVersion) records[0];
        try{
            this.CSVConverterToObject.convertCSVToRecord( contentVersion );
        }catch( Exception error ) {
            Messaging.sendEmail(
                new Messaging.SingleEmailMessage[] {
                    new EmailBuilder()
                    .withAddress( contentVersion.UserEmail__c )
                    .withSenderDisplayName( 'Salesforce CSV import' )
                    .withSubject( 'Erro no processo de importação de cargas' )
                    .withPlainTextBody( 'Deu erro na inserção/atualização de seus registros, contate um ADM!\n● Erro: ' + error.getStackTraceString() + '\n● Motivo: ' + error.getMessage() )
                    .build()
                }
            );
            ContentDocument contentDocument = this.contentDocumentRepository.findById( contentVersion.ContentDocumentId );
            delete contentDocument;
        }

    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id, VersionData, ObjectType__c, ContentDocumentId, ErrorsInInsert__c, UserEmail__c FROM ContentVersion WHERE isInsert__c = true AND IsLatest = true ORDER BY ContentDocument.CreatedDate ASC]);
    }

    public void finish(Database.BatchableContext context) {
        List<ContentVersion> contentVersion = this.contentVersionRepository.findByIsInsertAndIsLatest();

        if( contentVersion.isEmpty() ) {
            return;
        }

        Database.executeBatch(this);

    }

}