/**
 * @description: Class to provide stored StaticResource collections
 * @author: Reirysson Costa - Everymind
 */
public virtual with sharing class StaticResourceRepository  extends AbstractRepository {

    virtual
    public List<StaticResource> findByName( String name ) {
        return [
            SELECT
                Id
                , Name
            FROM
                StaticResource
            WHERE Name LIKE :name + '%'
        ];
    }
}