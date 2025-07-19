/**
 * @description: Test class for TestClassObjectHandler
 * @author: Guilherme Zwipp
 */
@isTest
public class TestClassObjectHandlerTest {

    @isTest
    private static void shouldEnrichAccountDescription(){

        Account account = (Account) new AccountFactory.DefaultRT( 'TestAccount' ).createRecord();

        TestClassObject__c testClassObject = (TestClassObject__c) 
            new TestClassObjectFactory.DefaultRT( account.Id, 'TestDescription' ).getRecord();

        Test.startTest();

        insert testClassObject;

        Test.stopTest();

        Account enrichedAccount = [SELECT Id, Description__c FROM Account WHERE Id = :account.Id];
        Assert.areEqual( 'TestDescription', enrichedAccount.Description__c, 'Description__c field must be: TestDescription' );

    }

}