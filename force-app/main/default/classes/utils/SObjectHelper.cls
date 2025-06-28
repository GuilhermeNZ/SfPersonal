/**
 * @description: Utility class to handle and working with SObjects
 * @author: Guilherme Zwipp
 */
public with sharing class SObjectHelper {
    
    public static String getFieldValue( SObject record, String field ) {

        List<String> splitedField = field.split('\\.');

        for ( Integer i = 0; i < splitedField.size(); i++ ) {
            if( i == splitedField.size() - 1 ) {
                return String.valueOf( record.get( splitedField[i] ) );
            }

            record = record.getSObject( splitedField[i] );
            if( record == null ) return null;
        }

        return null;
    }

}