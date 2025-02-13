/**
 * @description: Class to provide stored ContentDocument collections
 * @author: Guilherme Zwipp - Everymind
 */
public virtual class ContentDocumentRepository extends AbstractRepository {

    virtual
    public ContentDocument findById( String contentDocumentId ) {
        return [
            SELECT
                Id
            FROM
                ContentDocument
            WHERE Id = :contentDocumentId
        ];
    }

}