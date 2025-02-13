/**
 * @description: Class to provide stored ContentVersion collections
 * @author: Guilherme Zwipp - Everymind
 */
public virtual class ContentVersionRepository extends AbstractRepository {

    virtual
    public ContentVersion findByContentDocumentId( String contentDocumentId ) {
        return[
            SELECT 
                Id
                , VersionData
                , ContentDocumentId
            FROM 
                ContentVersion 
            WHERE ContentDocumentId =:contentDocumentId
        ];
    }

    virtual
    public List<ContentVersion> findByIsInsertAndIsLatest() {
        return [
            SELECT 
                Id
                , VersionData 
            FROM 
                ContentVersion 
            WHERE isInsert__c = true 
                AND IsLatest = true 
            ORDER BY ContentDocument.CreatedDate ASC
        ];
    }

    virtual
    public List<ContentVersion> findByIsExecuting() {
        return [
            SELECT 
                Id
                , isExecuting__c 
            FROM ContentVersion 
            WHERE isExecuting__c = true
        ];
    }

    virtual
    public List<ContentVersion> findByFirstPublishLocationIdAndRecordTypeId( List<String> firstPublishLocationIds, List<String> recordTypes ) {
        return [
            SELECT
                Id
                , isExecuting__c
                , FirstPublishLocationId
                , ContentDocumentId
            FROM
                ContentVersion
            WHERE FirstPublishLocationId IN :firstPublishLocationIds
                AND FirstPublishLocation.RecordTypeId IN :recordTypes
        ];
    }

}