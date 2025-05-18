/**
 * @description: Class to provide stored SObject collections
 * @author: Guilherme Zwipp - Everymind
 */
public virtual class SObjectRepository extends AbstractRepository {

    public List<SObject> buildAndFindByFieldAndValues( List<String> fields, String SObjectName, String fieldName, Set<String> fieldValues ) {

        String query = 'SELECT ' + String.join( fields, ',' ) + ' FROM ' + SObjectName + ' WHERE ' + fieldName + ' IN :fieldValues';

        return Database.query( query );
    }

    public List<SObject> findByIdsToUseInRulesExecution( List<String> sObjectIds ) {
        //Working
        return new List<SObject>();
    }

}