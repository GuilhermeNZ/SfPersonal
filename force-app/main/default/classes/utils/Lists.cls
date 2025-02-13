/**
 * @description: Utility class to handle and working with Lists
 * @author: Henrique Bustillos - Everymind
 */
public with sharing class Lists {

    public static List<String> byFields ( List<SObject> records, List<String> fields ) {

        if ( isEmpty(records) || isEmpty(fields) ) return new List<String>();

        List<String> fieldsValues = new List<String>();

        for ( SObject record : records ) {

            for ( String field : fields ) {

                if ( record.get(field) == null ) continue;

                fieldsValues.add( '' + record.get(field) );
            }
        }

        return fieldsValues;
    }

    public static List<String> byFields ( List<Object> records, Type objectType, List<String> fields ) {

        if ( isEmpty(records) || isEmpty(fields) ) return new List<String>();

        List<String> fieldsValues = new List<String>();

        for ( Object record : records ) {

            CObject coreRecord = new CObject(record);

            for ( String field : fields ) {

                if ( !coreRecord.containsKey( field ) ) continue;

                if ( coreRecord.get(field) == null ) continue;

                fieldsValues.add( '' + coreRecord.get(field) );
            }
        }

        return fieldsValues;
    }

    public static List<String> byRelatedFields ( List<SObject> records, String relationName, List<String> fields ) {

        if ( isEmpty(records) || isEmpty(fields) ) return new List<String>();
        if( String.isBlank( relationName ) ) return new List<String>();

        List<String> fieldsValues = new List<String>();

        for ( SObject record : records ) {

            SObject relatedRecord = record.getSObject( relationName );

            if( relatedRecord == null ) continue;

            for ( String field : fields ) {

                if ( relatedRecord.get(field) == null ) continue;

                fieldsValues.add( '' + relatedRecord.get(field) );
            }
        }

        return fieldsValues;
    }

    public static List<String> byCompositeKey ( List<SObject> records, List<String> keys, String splitValue ) {

        if( Lists.isEmpty(records) || Lists.isEmpty(keys) ) return new List<String>();  

        List<String> compositeKeys = new List<String>();
        
        for (SObject record : records) {
            List<String> keyParts = new List<String>();
            
            for (String key : keys) {
                String fieldValue = getFieldValue( record, key );

                if ( fieldValue == null ) continue;

                keyParts.add( fieldValue );
            }
        
            compositeKeys.add(String.join(keyParts, splitValue));
        }
        
        return compositeKeys;
    }

    private static String getFieldValue( SObject record, String field ) {

        List<String> splitedField = field.split('\\.');

        if( splitedField.size() == 1 ) {
            return (String) record.get( field );
        }else if( splitedField.size() == 2 ) {
            SObject relatedRecord = record.getSObject( splitedField[0] );

            if( relatedRecord == null ) return null;

            return (String) relatedRecord.get( splitedField[1] );
        }else if( splitedField.size() == 3) {
            SObject relatedRecord = record.getSObject( splitedField[0] ).getSObject( splitedField[1] );

            if( relatedRecord == null ) return null;

            return (String) relatedRecord.get( splitedField[2] );
        }else if( splitedField.size() == 4) {
            SObject relatedRecord = record.getSObject( splitedField[0] ).getSObject( splitedField[1] ).getSObject( splitedField[2] );

            if( relatedRecord == null ) return null;

            return (String) relatedRecord.get( splitedField[3] );
        }

        return '';

    }

    public static List<String> byField( List<Object> records, Type objectType, String field ) {
        return byFields( records, objectType, new List<String>{ field } );
    }

    public static List<String> byField( List<SObject> records, String field ) {
        return byFields( records, new List<String>{ field } );
    }

    public static List<String> byRelatedField( List<SObject> records, String relationName, String field ) {
        return byRelatedFields( records, relationName, new List<String>{ field } );
    }

    public static Boolean isEmpty( List<Object> records ) {
        return records == null || records.isEmpty();
    }

    public static List<List<Object>> doPartions(List<Object> records, Integer size, Type destType){
        checkNotNull(records);
        checkArgument(size > 0);
        checkNotNull(destType);
        return new Partition(records, size, destType).doPartition();
    }

    private static void checkNotNull(Object reference) {
        if (reference == null) throw new NullPointerException();
    }

    private static void checkArgument(Boolean expression) {
        if (!expression) throw new IllegalArgumentException();
    }

    private class Partition{
        private List<Object> items;
        private Integer splitSize;
        private Type destType;

        Partition(List<Object> records, Integer size, Type destType){
            this.items = records;
            this.splitSize = size;
            this.destType = destType;
        }

        List<List<Object>> doPartition(){

            List<List<Object>> result = (List<List<Object>>)destType.newInstance();

            List<Object> protoList = items.clone();

            protoList.clear();

            List<Object> tempList = protoList.clone();

            Integer index = 0, count = 0, size = items.size();

            while(index < size) {

                tempList.add(items.get(index++));

                ++count;

                if(count == splitSize) {
                    result.add(tempList);
                    tempList = protoList.clone();
                    count = 0;
                }
            }
            if(!tempList.isEmpty()) {
                result.add(tempList);
            }
            return result;
        }
    }

    public class IllegalArgumentException extends Exception {}
}