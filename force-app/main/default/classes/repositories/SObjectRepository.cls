/**
 * @description: Class to provide stored SObject collections
 * @author: Guilherme Zwipp
 */
public virtual class SObjectRepository extends AbstractRepository {

    public List<SObject> buildAndFindByFieldAndValues( List<String> fields, String SObjectName, String fieldName, Set<String> fieldValues ) {

        String query = 'SELECT ' + String.join( fields, ',' ) + ' FROM ' + SObjectName + ' WHERE ' + fieldName + ' IN :fieldValues';

        return Database.query( query );
    }

    public SObject buildAndFindById( List<String> fields, String SObjectName, String idValue ) {
        String query = 'SELECT ' + String.join( fields, ',' ) + ' FROM ' + SObjectName + ' WHERE Id = :idValue';

        List<SObject> sObjects = Database.query( query );

        return sObjects.isEmpty() ? null : sObjects[0];
    }

    public List<SObject> buildAndFindByIds( List<String> fields, String SObjectName, List<Id> ids ) {
        String query = 'SELECT ' + String.join( fields, ',' ) + ' FROM ' + SObjectName + ' WHERE Id IN :ids';

        return Database.query( query );
    }

}