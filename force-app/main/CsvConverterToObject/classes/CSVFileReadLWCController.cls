/**
 * @description: Class to controller apex operation in readCSVFileInLWC lwc
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class CSVFileReadLWCController {
    
    public static ContentVersionRepository contentVersionRepository;

    public static ContentDocumentRepository contentDocumentRepository;

    public static StaticResourceRepository staticResourceRepository;

    static{
        contentVersionRepository = new ContentVersionRepository();
        contentDocumentRepository = new ContentDocumentRepository();
        staticResourceRepository = new StaticResourceRepository();
    }

    @AuraEnabled
    public static boolean sendFileToInsert( Id contentDocumentId, String objectName, String userEmail ) {

        if(contentDocumentId == null) return false;

        sendFileToInsertFuture( contentDocumentId, objectName, userEmail );

        return true;
 
    }

    @future
    public static void sendFileToInsertFuture( Id contentDocumentId, String objectName, String userEmail ) {

        ContentVersion contentVersion = contentVersionRepository.findByContentDocumentId( contentDocumentId );

        RowIteratorUtility rowUtility = New RowIteratorUtility( contentVersion.VersionData.toString(),'\n' );

        String csvRecordList = rowUtility.next();

        if( !csvRecordList.contains( ';' ) ) {

            ContentDocument contentDocument = contentDocumentRepository.findById( contentDocumentId );
            contentDocumentRepository.deleteRecord( contentDocument );

            Messaging.sendEmail(
                new Messaging.SingleEmailMessage[] {
                    new EmailBuilder()
                    .withAddress( userEmail )
                    .withSenderDisplayName( 'Salesforce CSV import' )
                    .withSubject( Label.DataImportError )
                    .withPlainTextBody( Label.DataImportInvalidExcel + '\n' + Label.DataImportInvalidCSVMessage )
                    .build()
                }
            );

            return;
        }

        ContentVersion contentVersionToInsert = new ContentVersionBuilder()
            .withId( contentVersion.Id )
            .withIsInsert( true )
            .withObjectType( objectName )
            .withUserEmail( userEmail )
            .build();

        update contentVersionToInsert;
    }

    @AuraEnabled
    public static void deleteContentDocument( String contentDocumentId ) {
        delete ContentDocumentRepository.findById( contentDocumentId );
    }

    @AuraEnabled
    public static List<StaticResource> getStaticResources( String objectName ) {
        return staticResourceRepository.findByName( objectName );
    }

    public class CSVFileReadLWCException extends Exception {}

}