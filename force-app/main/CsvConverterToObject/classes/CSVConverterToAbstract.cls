public virtual class CSVConverterToAbstract {

    /*
     * Pendencias:
     * 1 - terminar método: enrichSObjectsToUpsertWithIdAndValueFields
     * 2 - Processo para quando vier um campo com os caracteres: - ou = ter uma tratativa diferente
     * 3 - Deixar a classe CSVConverterToObject abstrata
     * 4 - Testar
    */
    
    private String sObjectName;
    private Integer count;
    private String errorsInUpsert;
    private String uniqueKey;
    private String uniqueKeyFieldName;
    private Set<String> uniqueKeys;

    protected Map<String,Map<String,String>> valueByFieldNameByUniqueKey;
    protected Map<String,Map<String,List<String>>> fieldValuesByLookupUniqueKeyFieldByLookupObjectName;
    protected Map<String,String> fieldNameByLookupUniqueKeyField;
    protected Map<String,SObject> internalSObjectByUniqueKey;
    Map<String,Map<String,String>> lookupIdByValueByRelationshipName;

    //private DescribeSObjectResult describeSObjectResult;

    private SObjectRepository sObjectRepository;

    public CSVConverterToAbstract( String sObjectName ) {
        this.sObjectName = SObjectName;
        this.errorsInUpsert = '';
        this.count = 0;
        this.uniqueKey = '';
        this.uniqueKeyFieldName = '';
        this.uniqueKeys = new Set<String>();

        this.valueByFieldNameByUniqueKey = new Map<String,Map<String,String>>();
        this.fieldValuesByLookupUniqueKeyFieldByLookupObjectName = new Map<String,Map<String,List<String>>>();
        this.fieldNameByLookupUniqueKeyField = new Map<String,String>();
        this.internalSObjectByUniqueKey = new Map<String,SObject>();
        this.lookupIdByValueByRelationshipName = new Map<String,Map<String,String>>();

        //this.describeSObjectResult = ( (SObject)( Type.forName( 'Schema.'+sObjectName ).newInstance() ) ).getSObjectType().getDescribe();

        this.sObjectRepository = new SObjectRepository();
    }

    public virtual void transformColumnsInSObjects( List<String> columns, String importUserEmail ) {
        //Method to enrich map valueByFieldNameByUniqueKey with putValueByFieldNameBySObjectUniqueKey method
    }

    public virtual List<SObject> validateSObjectsToUpsert() {
        //Method to get Internal SObjects to call enrichSObjectsToUpsertWithIdAndValueFields method
        return this.enrichSObjectsToUpsertWithIdAndValueFields();
    }

    public virtual String getAndBuildErrorMessageInSObjectUpsert( Database.UpsertResult[] upsertResults, List<SObject> SObjectsWithError ) {
        //Class to build error Message in main class and call getErrorsInSObjectsUpsert method;
        return this.getErrorsInSObjectsUpsert( upsertResults, SObjectsWithError, 'FIELD_TEST' );
    }

    protected List<SObject> enrichSObjectsToUpsertWithIdAndValueFields() {
        //Refatorar
        //Falta terminar - Feito, testar mais cenários
        //Casting Dinamico do campo no futuro
        //Campos lookups - Feito, testar mais cenários
        //Usar ExternalId para os lookups
        this.getInternalAndLookupSObjects();
        Type SObjectType = Type.forName( this.sObjectName );

        List<SObject> newSObjects = (List<SObject>) Type.forName( 'List<' + this.sObjectName + '>').newInstance();

        for( String uniqueKey : this.uniqueKeys ) {

            SObject newSObject = (SObject) SObjectType.newInstance();

            Map<String,String> valueByFieldName = this.valueByFieldNameByUniqueKey.get( uniqueKey );

            for( String fieldName : valueByFieldName.keySet() ) {

                if( this.lookupIdByValueByRelationshipName.containsKey( fieldName ) ) {

                    if( !this.lookupIdByValueByRelationshipName.get( fieldName ).containsKey( valueByFieldName.get( fieldName ) ) ) continue;

                    newSObject.put( fieldName, this.lookupIdByValueByRelationshipName.get( fieldName ).get( valueByFieldName.get( fieldName ) ) ) ;
                }else{
                    newSObject.put( fieldName, valueByFieldName.get( fieldName ) ); 
                }

            }

            if( this.internalSObjectByUniqueKey.containsKey( uniqueKey ) ) newSObject.put( 'Id', this.internalSObjectByUniqueKey.get( uniqueKey ).get( 'Id' ) );

            newSObjects.add( newSObject );

        }

        return newSObjects;

    }

    private void getInternalAndLookupSObjects() {

        this.getInternalSObjects();
        this.getLookupSObjects();

    }

    private void getInternalSObjects() {
        List<SObject> internalSObjects = this.sObjectRepository.buildAndFindByFieldAndValues( 
            new List<String>{'Id',this.uniqueKeyFieldName}
            , this.SObjectName
            , this.uniqueKeyFieldName
            , this.uniqueKeys
        );

        this.internalSObjectByUniqueKey = Maps.indexBy( this.uniqueKeyFieldName, internalSObjects );
    }

    private void getLookupSObjects() {

        //Refatorar

        for( String lookupObjectName : this.fieldValuesByLookupUniqueKeyFieldByLookupObjectName.keySet() ) {

            for( String lookupUniqueKeyField : this.fieldValuesByLookupUniqueKeyFieldByLookupObjectName.get( lookupObjectName ).keySet() ) {

                String relationshipName = this.fieldNameByLookupUniqueKeyField.get( lookupUniqueKeyField );

                List<String> fieldValues = this.fieldValuesByLookupUniqueKeyFieldByLookupObjectName.get( lookupObjectName ).get( lookupUniqueKeyField );

                List<SObject> lookupObjects = this.sObjectRepository.buildAndFindByFieldAndValues(
                    new List<String>{'Id',lookupUniqueKeyField}
                    , lookupObjectName
                    , lookupUniqueKeyField
                    , new Set<String>( fieldValues )
                );

                if( !this.lookupIdByValueByRelationshipName.containsKey( relationshipName ) ) {
                    this.lookupIdByValueByRelationshipName.put( relationshipName, new Map<String,String>() );
                }

                for( SObject lookupObject : lookupObjects ) {
                    this.lookupIdByValueByRelationshipName.get( relationshipName ).put( (String) lookupObject.get( lookupUniqueKeyField ), (String) lookupObject.get( 'Id' ) );
                }

            }

        }

    }

    protected String getErrorsInSObjectsUpsert( Database.UpsertResult[] upsertResults, List<SObject> SObjectsWithError, String errorMessage ) {

        List<String> errorMessageFields = StringUtil.extractFieldsCSVConverter( errorMessage );

        for( Integer i = 0 ; i < upsertResults.size() ; i++ ) {
            if( upsertResults[i].isSuccess() ) continue;

            this.errorsInUpsert += this.replaceErrorMessageFields( errorMessage, errorMessageFields, SObjectsWithError[i], upsertResults[i].getErrors()[0].getMessage() );
        }

        return this.errorsInUpsert;
    }

    private String replaceErrorMessageFields( String errorMessage, List<String> errorMessageFields, SObject SObjectWithError, String sObjectError ) {

        errorMessage = errorMessage.replace( 'ERROR_MESSAGE', sObjectError );

        for( String errorMessageField : errorMessageFields ) {
            errorMessage = errorMessage.replace( 'FIELD_' + errorMessageField, (String) SObjectWithError.get( errorMessageField ) );
        }

        return errorMessage + '\n';
    }

    protected void sumCounter() {
        this.count++;
    }

    protected Set<String> getUniqueKeys() {
        return this.uniqueKeys;
    }

    public Integer getCount() {
        return this.count;
    }

    public String getErrorsInUpsert() {
        return this.errorsInUpsert;
    }

    protected void putUniqueKeyAndUniqueKeyFieldName( String uniqueKey, String uniqueKeyFieldName ) {
        this.uniqueKey = StringHelper.removeLineBreakCharacters( uniqueKey );
        this.uniqueKeyFieldName = uniqueKeyFieldName;
        this.uniqueKeys.add( this.uniqueKey );
        this.sumCounter();
    }

    protected void putValueByFieldNameBySObjectUniqueKey( String fieldValue, String fieldName ) {

        if( String.isBlank( this.uniqueKey ) || String.isBlank( fieldName ) || String.isBlank( fieldValue ) ) return;//Trowrh error

        fieldValue = StringHelper.removeLineBreakCharacters( fieldValue );

        this.valueByFieldNameByUniqueKey = Maps.putValueBySubKeyByMainKey( this.valueByFieldNameByUniqueKey, fieldValue, fieldName, this.uniqueKey );
    }

    protected void putLookupField( String fieldValue, String fieldName, String lookupObject, String lookupUniqueKeyField ) {

        if( String.isBlank( fieldValue ) || String.isBlank( fieldName ) || String.isBlank( lookupObject ) || String.isBlank( lookupUniqueKeyField ) ) return;//Trowrh error

        fieldValue = StringHelper.removeLineBreakCharacters( fieldValue );

        this.putValueByFieldNameBySObjectUniqueKey( fieldValue, fieldName );

        this.fieldValuesByLookupUniqueKeyFieldByLookupObjectName = (Map<String,Map<String,List<String>>>) Maps.putValueBySubKeyByMainKey( fieldValuesByLookupUniqueKeyFieldByLookupObjectName, fieldValue, lookupUniqueKeyField, lookupObject );
        this.fieldNameByLookupUniqueKeyField = (Map<String,String>) Maps.putValue( this.fieldNameByLookupUniqueKeyField, fieldName, lookupUniqueKeyField );
    }

}