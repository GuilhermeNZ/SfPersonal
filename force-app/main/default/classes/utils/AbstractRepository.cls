/**
 * Provide Base Repository Implementations
 * @author ercarval - topi
 */
public abstract class AbstractRepository {

    virtual
    public SObject save (SObject aggregate) {

        if (aggregate == null) return null;

        upsert aggregate;

        return aggregate;
    }

    virtual
    public List<SObject> save (List<SObject> aggregates) {

        if (aggregates == null) return new List<SObject>();

        if (aggregates.isEmpty()) return aggregates;

        upsert aggregates;

        return aggregates;

    }

    virtual
    protected List<SObject> filterWithId (List<SObject> aggregates) {

        List<SObject> aggregatesToStore = new  List<SObject>();

        for (SObject aggregate : aggregates) {
            if (aggregate.id != null) aggregatesToStore.add (aggregate);
        }

        return aggregatesToStore;
    }

    virtual
    protected List<SObject> filterWithOutId (List<SObject> aggregates) {
        List<SObject> aggregatesToStore = new  List<SObject>();

        for (SObject aggregate : aggregates) {
            if (aggregate.id == null) aggregatesToStore.add (aggregate);
        }

        return aggregatesToStore;
    }

    virtual
    public List<Database.SaveResult> updateAll ( List<SObject> aggregates ) {

        if (aggregates == null || aggregates.isEmpty()) return new List<Database.SaveResult>();

        return Database.update (aggregates, false);
    }

    virtual
    public List<Database.SaveResult> insertAll ( List<SObject> aggregates ) {

        if (aggregates == null || aggregates.isEmpty()) return new List<Database.SaveResult>();

        return Database.insert (aggregates, false);
    }

    virtual
    public List<Database.UpsertResult> upsertAll ( List<SObject> aggregates ) {

        if (aggregates == null || aggregates.isEmpty()) return new List<Database.UpsertResult>();

        return Database.upsert (aggregates, false);
    }

    virtual
    public List<Database.UpsertResult> upsertAllOrNone ( List<SObject> aggregates ) {

        if (aggregates == null || aggregates.isEmpty()) return new List<Database.UpsertResult>();

        return Database.upsert (aggregates, true);
    }

    virtual
    public List<SObject> upsertRecords(List<SObject> records) {
        if (!records.isEmpty()) {
            upsert records;
        }
        return records;
    }
    
    virtual
    public void deleteRecords(List<SObject> records) {
        if (!records.isEmpty()) {
            delete records;
        }
    }

    virtual
    public void deleteRecord( SObject record ) {
        if( record == null ) return;
        delete record;
    }
    
}