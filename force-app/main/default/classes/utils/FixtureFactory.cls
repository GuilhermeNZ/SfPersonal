/**
 * @description: Fixture Factory for test classes
 * @author: Henrique Bustillos
 */
@isTest
public class FixtureFactory {

    private static Integer idCountForTest = 1;

    public static List<String> generateFakeIds( Schema.SObjectType sobjectType, Integer quantity ) {

        List<String> fakeIds = new List<String>();

        for( Integer i = 0 ; i < quantity ; i++ ) {
            fakeIds.add( generateFakeId( sobjectType ) );
        }

        return fakeIds;
    }

    public static String generateFakeId(Schema.SObjectType sobjectType) {

        String result = String.valueOf(idCountForTest++);

        return sobjectType.getDescribe().getKeyPrefix() + '0'.repeat(12 - result.length()) + result;
    }

    public static List<String> generateFakeIds18( Schema.SObjectType sobjectType, Integer quantity ) {
        List<String> fakeIds = new List<String>();

        for( Integer i = 0 ; i < quantity ; i++ ) {
            fakeIds.add( generateFakeId18( sobjectType ) );
        }

        return fakeIds;
    }

    public static String generateFakeId18(Schema.SObjectType sobjectType) {
        return generateFakeId(sobjectType)+'AAA';
    }

    public static List<SObject> enrichSObjectsWithFakeIds( List<SObject> objectsToEnrich, Schema.SObjectType sobjectType ) {
        if( objectsToEnrich.isEmpty() ) return new List<SObject>();
        for( SObject objectToEnrich : objectsToEnrich ) {
            if( String.isBlank( objectToEnrich.Id ) ) objectToEnrich.Id = generateFakeId18( sobjectType );
        }

        return objectsToEnrich;
    }

}