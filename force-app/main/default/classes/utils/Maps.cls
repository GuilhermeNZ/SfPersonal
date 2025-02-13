/**
 * @description: Utility class to handle and working with Maps
 * @author: Henrique Bustillos & Guilherme Zwipp - Everymind
 */
public without sharing class Maps {

    public static Map<String, SObject> indexBy ( String fieldName, List<SObject> records ) {

        if ( Lists.isEmpty(records) ) return newEmptyMap(records);

        Map<String, SObject> values = newEmptyMap(records);

        for ( SObject record : records ) {

            String value = getFieldValue( record, fieldName );

            if ( value == null ) continue;

            values.put( value, record );
        }

        return values;
    }

    public static Map<String,Object> putValue( Map<String,Object> valueByKey, Object value, String key ) {
        valueByKey.put( key, value );

        return valueByKey;
    }

    public static Map<String,Map<String,String>> putValueBySubKeyByMainKey( Map<String,Map<String,String>> valueByKeyByMainKey, String value, String subKey, String mainKey ) {

        if( valueByKeyByMainKey.containsKey( mainKey ) ) valueByKeyByMainKey.get( mainKey ).put( subKey, value );
        else valueByKeyByMainKey.put( mainKey, new Map<String,String>{ subKey => value } );

        return valueByKeyByMainKey;
    }

    public static Map<String,Map<String,List<Object>>> putValueBySubKeyByMainKey( Map<String,Map<String,List<Object>>> valuesByKeyByMainKey, String value, String subKey, String mainKey ) {

        if( !valuesByKeyByMainKey.containsKey( mainKey ) ) valuesByKeyByMainKey.put( mainKey, new Map<String,List<Object>>() );
        if( !valuesByKeyByMainKey.get( mainKey ).containsKey( subKey ) ) valuesByKeyByMainKey.get( mainKey ).put( subKey, new List<Object>() );

        valuesByKeyByMainKey.get( mainKey ).get( subKey ).add( value );

        return valuesByKeyByMainKey;
    }

    public static SObject getMapValue ( Map<String,SObject> sObjectByKey, String key ) {
        if( sObjectByKey.containsKey( key ) ) return sObjectByKey.get( key );
        return null;
    }

    private static String getFieldValue( SObject record, String field ) {

        List<String> splitedField = field.split('\\.');

        for ( Integer i = 0; i < splitedField.size(); i++ ) {
            
            if( i == splitedField.size() - 1 ) {
                return (String) record.get( splitedField[i] );
            }

            record = record.getSObject( splitedField[i] );

            if( record == null ) return null;
        }

        return '';

    }

    private static Map<String, SObject> newEmptyMap (List<SObject> records) {

        Type sobjectType = Type.forName( 'Map<String, ' + records.getSObjectType() + '>' );

        return (Map<String, SObject>) sobjectType.newInstance();
    }

}