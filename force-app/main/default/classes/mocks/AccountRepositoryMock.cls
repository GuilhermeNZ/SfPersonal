/**
 * @description: Mock for AccountRepository class
 * @author: Guilherme Zwipp
 */
@isTest
public class AccountRepositoryMock extends AccountRepository {

    String payload = '';

    public AccountRepositoryMock( String payload ) {
        this.payload = payload;
    }

    public override List<Account> findByIds( Set<String> ids ) {
        return (List<Account>) JSON.deserialize( this.payload, List<Account>.class );
    }

    public override SObject save (SObject aggregate) {
        return aggregate;
    }

    public override List<SObject> save (List<SObject> aggregates) {
        return aggregates;
    }

}