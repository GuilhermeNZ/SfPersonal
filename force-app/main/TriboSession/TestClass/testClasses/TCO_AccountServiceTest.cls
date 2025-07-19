/**
 * @description: Test class for TCO_AccountService
 * @author: Guilherme Zwipp
 */
@isTest
public class TCO_AccountServiceTest {
    
    @isTest
    private static void shouldEnrichAccountsDescriptionByTestClassObjects() {

        String accountFakeId = FixtureFactory.generateFakeId18( Account.getSobjectType() );

        String accountsPayload = '[{"Id":"'+ accountFakeId +'","Description__c":""}]';

        TCO_AccountService service = new TCO_AccountService();
        service.setRepository( new AccountRepositoryMock( accountsPayload ) );

        String testClassObjectsPayload = '[{"Account__c":"'+ accountFakeId +'","Description__c":"TestDescription"}]';

        List<TestClassObject__c> testClassObjects = TestClassObjectFactory.fromJsonArray( testClassObjectsPayload );

        Test.startTest();

        List<Account> enrichedAccounts = service.enrichAccountsDescriptionByTestClassObjects( testClassObjects );

        Test.stopTest();

        Assert.isFalse( enrichedAccounts.isEmpty(), 'Should return enrichedAccounts' );
        Assert.areEqual( 1, enrichedAccounts.size(), 'Should return one enrichedAccount' );
        Assert.areEqual( 'TestDescription', enrichedAccounts[0].Description__c, 'Description__c field must be: TestDescription' );
    }

}