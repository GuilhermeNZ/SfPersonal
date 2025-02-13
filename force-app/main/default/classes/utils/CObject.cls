/*
 * CoreObject: Class to provide a generic way to get a field value from an generic Object (ANY)
 * @author: Henrique Bustillos - Everymind
 */
public virtual class CObject {

    Object record;

    public CObject (Object record) {
        this.record = record;
    }

    public Object get( String fieldName ) {

        return this.getUntypedInstance().get( fieldName );
    }

    public Boolean containsKey ( String fieldName ) {

        return this.getUntypedInstance().containsKey( fieldName );
    }

    private Map<String, Object> getUntypedInstance () {

        String payload = JSON.serialize( this.record );

        Map<String, Object> untypedInstance = ( Map<String, Object> ) JSON.deserializeUntyped( payload );

        return untypedInstance;
    }
}