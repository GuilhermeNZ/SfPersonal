/**
 * @description: Test class for Maps utility class
 * @author: Henrique Bustillos - Everymind
*/
@isTest
public class MapsTest {

    public static List<Account> setup() {
        return ListsTest.setup();
    }

    @isTest
    static void itShouldReturnAccountsIndexedByField () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, Account> accountsByBillingState = (Map<String,Account>) Maps.indexBy( 'BillingState', accounts );

        Test.stopTest();

        System.assertEquals( 2, accountsByBillingState.size(), 'Indexed Accounts size should be 2' );
    }

    @isTest
    static void itShouldReturnAccountsIndexedByFieldAndSobjectType () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, Account> accountsGroupedByBillingState = (Map<String, Account>) Maps.indexBy( 'BillingState', accounts, Account.class );

        Test.stopTest();

        System.assertEquals( 2, accountsGroupedByBillingState.size(), 'Grouped Accounts size should be 2' );
        System.assert(accountsGroupedByBillingState.containsKey('São Paulo'), 'Accounts Must Have (São Paulo)');

    }

    @isTest
    static void itShouldReturnEmptyIndexedMap () {

        List<SObject> records = new List<SObject>();

        Test.startTest();

        Map<String, SObject> recordsByBillingState = Maps.indexBy( 'BillingState', records );

        Test.stopTest();

        System.assert( recordsByBillingState.isEmpty(), 'Indexed Accounts should be empty' );
    }

    @isTest
    static void itShouldReturnAccountsIndexedByCompositeKey () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, Account> accountsByNameAndBillingState = (Map<String,Account>) Maps.indexByCompositeKey( 'Name', 'BillingState', accounts );

        Test.stopTest();

        Assert.isNotNull( accountsByNameAndBillingState );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 1,São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 2,São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 3,Rio de Janeiro' ) );
    }


    @isTest
    static void itShouldReturnAccountsIndexedByCompositeKeyNewMethodSplitValue () { 

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, Account> accountsByNameAndBillingState = (Map<String,Account>) Maps.indexByCompositeKey( accounts, new List<String>{ 'Name', 'BillingState' }, '-' );

        Test.stopTest();

        Assert.isNotNull( accountsByNameAndBillingState );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 1-São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 2-São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 3-Rio de Janeiro' ) );

    }

    @isTest
    static void itShouldReturnAccountsIndexedByCompositeKeyNewMethod () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, Account> accountsByNameAndBillingState = (Map<String,Account>) Maps.indexByCompositeKey( accounts, new List<String>{ 'Name', 'BillingState' } );

        Test.stopTest();

        Assert.isNotNull( accountsByNameAndBillingState );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 1,São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 2,São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 3,Rio de Janeiro' ) );

    }

    @isTest
    static void itShouldReturnAccountsGroupByCompositeKey () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, List<Account>> accountsByNameAndBillingState = (Map<String,List<Account>>) Maps.groupByCompositeKey( accounts, new List<String>{'Name','BillingState'} );

        Test.stopTest();

        Assert.isNotNull( accountsByNameAndBillingState );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 1,São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 2,São Paulo' ) );
        Assert.isTrue( accountsByNameAndBillingState.containsKey( 'Account 3,Rio de Janeiro' ) );

    }

    @isTest
    static void itShouldReturnIndexedFieldByAnotherFieldMap() {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, Decimal> accountsByBillingState = (Map<String, Decimal>) Maps.indexFieldBy( 'BillingState', 'NumberOfEmployees', accounts );

        Test.stopTest();

        System.assertEquals( 2, accountsByBillingState.size() );
        System.assertEquals( 3, accountsByBillingState.get('Rio de Janeiro') );
    }

    @isTest
    static void itShouldReturnGroupedMap () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, List<Account>> accountsGroupedByBillingState = (Map<String, List<Account>>) Maps.groupBy( 'BillingState', accounts );

        Test.stopTest();

        System.assertEquals( 2, accountsGroupedByBillingState.size(), 'Grouped Accounts size should be 2' );
        System.assertEquals( 2, accountsGroupedByBillingState.get('São Paulo').size(), 'Grouped Accounts size should be 2' );
    }

    @isTest
    static void itShouldReturnEmptyGroupedMap () {

        List<Account> accounts = new List<Account>();

        Test.startTest();

        Map<String, List<Account>> accountsGroupedByBillingState = (Map<String, List<Account>>) Maps.groupBy( 'BillingState', accounts );

        Test.stopTest();

        System.assert( accountsGroupedByBillingState.isEmpty(), 'Grouped Accounts should be empty' );
    }

    @isTest
    static void itShouldReturnUntypedGroupedMap () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, List<Account>> accountsGroupedByBillingState = (Map<String, List<Account>>) Maps.groupBy( 'BillingState', accounts, Account.class );

        Test.stopTest();

        System.assertEquals( 2, accountsGroupedByBillingState.size(), 'Grouped Accounts size should be 2' );
        System.assertEquals( 2, accountsGroupedByBillingState.get('São Paulo').size(), 'Grouped Accounts size should be 2' );
    }

    @isTest
    static void itShouldReturnEmptyUntypedGroupedMap () {

        List<Account> accounts = new List<Account>();

        Test.startTest();

        Map<String, List<Account>> accountsGroupedByBillingState = (Map<String, List<Account>>) Maps.groupBy( 'BillingState', accounts, Account.class );

        Test.stopTest();

        System.assert( accountsGroupedByBillingState.isEmpty(), 'Grouped Accounts should be empty' );
    }

    @isTest
    static void itShouldReturnSObjectIndexedMapByField () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, Object> accountsByName = Maps.indexByFieldAndValue(
            accounts
            , 'Name'
            , 'BillingState'
            , 'São Paulo'
        );

        Test.stopTest();

        System.assert( accountsByName.containsKey('Account 1'), 'Indexed map should contains the key' );
        System.assert( accountsByName.containsKey('Account 2'), 'Indexed map should contains the key' );
    }

    @isTest
    static void returnGroupedMapByLookup () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, List<Account>> accountsByParentName = (Map<String, List<Account>>) Maps.groupByLookupField( 'Parent', 'Name', accounts );

        Test.stopTest();

        System.assertEquals( 2, accountsByParentName.size(), 'Grouped Accounts size should be 2' );
        System.assertEquals( 1, accountsByParentName.get('ParentAccount 1').size(), 'Grouped Accounts size should be 1' );
    }

    @isTest
    static void returnEmptyWhenGroupByLookup () {

        List<Account> accounts = new List<Account>();

        Test.startTest();

        Map<String, List<Account>> accountsByParentName = (Map<String, List<Account>>) Maps.groupByLookupField( 'Parent', 'Name', accounts );

        Test.stopTest();

        Assert.isTrue( accountsByParentName.isEmpty(), 'Grouped Accounts size should be empty' );
    }

    @isTest
    static void returnEmptyWhenGroupMapByLookupFieldNotFound () {

        List<Account> accounts = MapsTest.setup();

        Test.startTest();

        Map<String, List<Account>> accountsByParentName = (Map<String, List<Account>>) Maps.groupByLookupField( 'Parent', 'NumberOfEmployees', accounts );

        Test.stopTest();

        Assert.isTrue( accountsByParentName.isEmpty(), 'Grouped Accounts size should be empty' );
    }

    @isTest
    static void itShouldReturnMapValuesInList () {

        List<Account> accounts = MapsTest.setup();

        Map<String, List<Account>> stringByAccount = new Map<String, List<Account>>();
        stringByAccount.put('MapTest', accounts);

        Test.startTest();

        List<Account> accountsReturned = (List<Account>) Maps.aggregateValues( stringByAccount );

        Test.stopTest();

        System.assertEquals( accounts.size(), accountsReturned.size(), 'Indexed Accounts size should be: '+accounts.size() );
    }
}