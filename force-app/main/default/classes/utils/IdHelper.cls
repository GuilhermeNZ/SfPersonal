/**
 * @description: Utility class to handle and working with Ids
 * @author: Guilherme Zwipp
 */
public with sharing class IdHelper {
    
    public static Set<String> getSObjectApiNamesByIds( List<Id> sObjectIds ) {
        Set<String> sObjectApiNames = new Set<String>();

        for( Id sObjectId : sObjectIds ) {
            sObjectApiNames.add( sObjectId.getSObjectType().getDescribe().getName() );
        }

        return sObjectApiNames;
    }

    public static Map<String,List<Id>> buildMapIdsBySObjectApiName( List<Id> sObjectIds ) {
        Map<String,List<Id>> idsBySObjectApiName = new Map<String,List<Id>>();

        for( Id sObjectId : sObjectIds ) {
            String sObjectApiName = sObjectId.getSObjectType().getDescribe().getName();

            if( !idsBySObjectApiName.containsKey( sObjectApiName ) ) idsBySObjectApiName.put( sObjectApiName, new List<Id>() );
            idsBySObjectApiName.get( sObjectApiName ).add( sObjectId );
        }

        return idsBySObjectApiName;
    }

}