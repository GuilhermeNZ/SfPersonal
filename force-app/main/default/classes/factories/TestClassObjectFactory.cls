/**
 * @description: Factory to create TestClassObject__c objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public class TestClassObjectFactory {

    public static TestClassObject__c buildNew( String accountId, String description ) {
        return new TestClassObject__c(
            Account__c = accountId,
            Description__c = description
        );
    }

    public class DefaultRT extends SObjectFactory {

        public DefaultRT( String accountId, String description ) {
            super( buildNew( accountId, description ) );
        }

    }

    public static List<TestClassObject__c> fromJsonArray( String testClassObjectsPayload ) {
        return (List<TestClassObject__c>) JSON.deserialize( testClassObjectsPayload, List<TestClassObject__c>.class );
    }

}