/**
 * @description: Test class for AccountEnricher
 * @author: Guilherme Zwipp
 */
@isTest
public class AccountEnricherTest {
    
    @isTest
    private static void enrichWithDescription() {

        String accountPayload = '{"Description__c":""}';

        Account account = AccountFactory.fromJson( accountPayload );

        Test.startTest();

        AccountEnricher enricher = AccountEnricher.getInstance();
        Account enrichedAccount = enricher.withDescription( account, 'TestDescription' );

        Test.stopTest();

        Assert.isNotNull( enrichedAccount );
        Assert.areEqual( 'TestDescription', enrichedAccount.Description__c );
    }

}