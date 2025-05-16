/**
 * @description: Factory to create Account objects in test context
 * @author: Guilherme Zwipp
 */
@isTest
public class AccountFactory {

    public static Account buildNew( String name ) {
        return new Account(
            Name = name
        );
    }

    public class DefaultRT extends SObjectFactory {

        public DefaultRT( String name ) {
            super( buildNew( name ) );
        }

    }

    public static Account fromJson( String accountPayload ) {
        return (Account) JSON.deserialize( accountPayload, Account.class );
    }

}