/**
 * @description: Class responsable to make DML Operations in RulePath execution
 * @author: Guilherme Zwipp
 */
public with sharing class RulePathDMLOperations {

    private static RulePathDMLOperations instance = null;

    public static RulePathDMLOperations getInstance(){
        if( instance == null ) instance = new RulePathDMLOperations();
        return instance;
    }

    ApprovalProcessService approvalProcessServiceInstance;

    sObjectRepository sObjectRepository;

    private RulePathDMLOperations(){
        this.sObjectRepository = new sObjectRepository();

        this.approvalProcessServiceInstance = ApprovalProcessService.getInstance();
    }
    
    public void upsertResultsByClassName( Map<String,Map<String,List<SObject>>> resultsByClassName ) {

        Map<String,Set<SObject>> sObjectsToUpsertBySObjectName = this.provideSObjectsToUpsertBySObjectName( resultsByClassName );

        //Working
        Set<String> sObjectNames = new Set<String>(); //Necessary to define dml order
        if( sObjectsToUpsertBySObjectName.containsKey( 'Quote' ) ) sObjectNames.add( 'Quote' );
        if( sObjectsToUpsertBySObjectName.containsKey( 'TransferOrder' ) ) sObjectNames.add( 'TransferOrder' );
        if( sObjectsToUpsertBySObjectName.containsKey( 'DeliveryOrder' ) ) sObjectNames.add( 'DeliveryOrder' );
        if( sObjectsToUpsertBySObjectName.containsKey( 'Order' ) ) sObjectNames.add( 'Order' );

        sObjectNames.addAll( sObjectsToUpsertBySObjectName.keySet() );

        Set<SObject> sObjectsToUpsert = new Set<SObject>();

        for( String sObjectToUpsertName : sObjectNames ) {

            List<SObject> sObjectsToUpsertInMap = new List<SObject>( sObjectsToUpsertBySObjectName.get( sObjectToUpsertName ) );
            sObjectsToUpsertInMap = this.validationsBeforeUpsert( sObjectsToUpsertInMap, sObjectToUpsertName );

            if( sObjectsToUpsertInMap.size() > 10000 ) {
                List<List<SObject>> results = (List<List<SObject>>) Lists.doPartions( sObjectsToUpsertInMap, 10000, Type.forName( 'List<List<SObject>>' ) );
            
                for( List<SObject> result : results ) {

                    if( result.size() == 10000 ) {
                        this.sObjectRepository.save( result );
                    }else{
                        sObjectsToUpsert.addAll( result );
                    }
                }

            }else{
                sObjectsToUpsert.addAll( sObjectsToUpsertInMap );
            }

            this.sObjectRepository.save( new List<SObject>( sObjectsToUpsert ) );
            sObjectsToUpsert.clear();

        }

        if( !sObjectsToUpsert.isEmpty() ) this.sObjectRepository.save( new List<SObject>( sObjectsToUpsert ) );
    }

    private Map<String,Set<SObject>> provideSObjectsToUpsertBySObjectName( Map<String,Map<String,List<SObject>>> resultsByClassName ) {
        Map<String,Set<SObject>> sObjectsToUpsertBySObjectName = new Map<String,Set<SObject>>();

        for( String className : resultsByClassName.keySet() ) {

            Map<String,List<SObject>> sObjectsByName = resultsByClassName.get( className );

            for( String sObjectName : sObjectsByName.keySet() ) {

                if( sObjectsByName.get( sObjectName ) == null ) continue;

                if( !sObjectsToUpsertBySObjectName.containsKey( sObjectName ) ) {
                    sObjectsToUpsertBySObjectName.put( sObjectName, new Set<SObject>() );
                }

                sObjectsToUpsertBySObjectName.get( sObjectName ).addAll( sObjectsByName.get( sObjectName ) );
            }

        }

        return sObjectsToUpsertBySObjectName;
    }

    //Working
    private List<SObject> validationsBeforeUpsert( List<SObject> sObjectsToUpsert, String sObjectName ) {

        // if( sObjectName == 'OrderItem' ) {
        //     return this.validationsBeforeUpsertOrderItem( (List<OrderItem>) sObjectsToUpsert );
        // }else if( sObjectName == 'Order' ) {
        //     return this.validationsBeforeUpsertOrder( (List<Order>) sObjectsToUpsert );
        // }

        return sObjectsToUpsert;
    }

    // private List<SObject> validationsBeforeUpsertOrderItem( List<OrderItem> orderItems ) {

    //     for( OrderItem orderItem : orderItems ) {
    //         if( orderItem.Order == null ) continue;
    //         orderItem.OrderId = orderItem.Order.Id;
    //     }

    //     return orderItems;
    // }

    // private List<SObject> validationsBeforeUpsertOrder( List<Order> orders ) {

    //     for( Order order : orders ) {
    //         if( order.TransferOrder__r != null ) order.TransferOrder__c = order.TransferOrder__r.Id;
    //         if( order.DeliveryCustomerOrder__r != null ) order.DeliveryCustomerOrder__c = order.DeliveryCustomerOrder__r.Id;
    //     }

    //     return orders;
    // }

    public void startApprovalProcess( List<Approval.ProcessSubmitRequest> approvalProcess ){
        if( !approvalProcess.isEmpty() ) this.approvalProcessServiceInstance.process( approvalProcess );
    }

    @TestVisible
    private void setSObjectRepository( SObjectRepository sObjectRepositoryMock ) {
        this.sObjectRepository = sObjectRepositoryMock;
    }

}