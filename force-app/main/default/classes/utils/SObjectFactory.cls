/**
 * @author Renato Matheus Simião
 * @version 1.0
 * @date 2018-11-26
 * @description Framework to provide functionality in test class
 */
public abstract class SObjectFactory {

	public Integer DEFAULT_BULK_RECORDS = 20; // 20 is the minimum amount recommended by Salesforce
	public String FIELD_INTERATOR = 'Name';

	public List<SObject> LIST_SOBJECT_FIELD_INTERATOR; // if null use only FIELD_INTERATOR, else use Id of this list + FIELD_INTERATOR
	
	private SObject record {get;set;}
	private List<SObject> lRecord {get;set;}

	public SObjectFactory(SObject pRecord) {
		
		record = pRecord;
	}

	public void setRecord(SObject pRecord) {

		record = pRecord;
	}

	public SObject getRecord() {

		return record;
	}

	public SObject cloneRecord() {

		return record.clone();
	}

	public virtual SObject createRecord() {

		if (record.Id == null) {
			insert record;
			//System.debug('record='+JSON.serialize(record));
		}

		return record;
	}

	public List<SObject> getRecords() {

		if (lRecord == null) {

			lRecord = new List<SObject>();

			for (Integer i = 0; i < DEFAULT_BULK_RECORDS; i++) {

				SObject recordCloned = record.clone();
			
				if (LIST_SOBJECT_FIELD_INTERATOR == null)
					recordCloned.put(FIELD_INTERATOR, record.get(FIELD_INTERATOR) + ' ' +i);
				else recordCloned.put(FIELD_INTERATOR, LIST_SOBJECT_FIELD_INTERATOR.get(i).Id);

				lRecord.add(recordCloned);
			}
		}

		return lRecord;
	}

	public List<SObject> createRecords() {

		lRecord = getRecords();
		
		if (!lRecord.isEmpty() && lRecord.get(0).Id == null)
			insert lRecord;
		
		return lRecord;
	}

	public static Database.UpsertResult[] upsertResultFromJsonArray( String payload ) {
		return (Database.UpsertResult[]) JSON.deserialize( payload, Database.UpsertResult[].class );
	}

	public static Map<String, Map<String, String>> fromJsonMapStringMap( String payload ) {
		return (Map<String, Map<String, String>>) JSON.deserialize( payload, Map<String, Map<String, String>>.class );
	}

}