/**
 * @description: Repository for RulePathSObjectSetting__c Object
 * @author: Guilherme Zwipp
 */
public virtual class RulePathSObjectSettingRepository extends AbstractRepository{

    private static RulePathSObjectSettingRepository instance = null;

    public static RulePathSObjectSettingRepository getInstance() {
        if( instance == null ) instance = new RulePathSObjectSettingRepository();
        return instance;
    }

    protected RulePathSObjectSettingRepository() {}

    public virtual RulePathSObjectSetting__c findByObjectAPIName( String objectApiName ) {
        List<RulePathSObjectSetting__c> rulePathSObjectSettings = this.findByObjectAPINames( new Set<String>{objectApiName} );
        return rulePathSObjectSettings.isEmpty() ? null : rulePathSObjectSettings[0];
    }

    public virtual List<RulePathSObjectSetting__c> findByObjectAPINames( List<String> objectApiNames ) {
        return this.findByObjectAPINames( new Set<String>( objectApiNames ) );
    }

    public virtual List<RulePathSObjectSetting__c> findByObjectAPINames( Set<String> objectApiNames ) {
        return[
            SELECT
                Id
                , ObjectAPIName__c
                , (
                    SELECT
                        Name
                    FROM 
                        RulePathFieldsSettings__r
                    WHERE Name != null
                )
            FROM
                RulePathSObjectSetting__c
            WHERE ObjectAPIName__c IN :objectApiNames
        ];
    }

    @TestVisible
    private static void setMock( RulePathSObjectSettingRepository mockInstance ) {
        instance = mockInstance;
    }

}