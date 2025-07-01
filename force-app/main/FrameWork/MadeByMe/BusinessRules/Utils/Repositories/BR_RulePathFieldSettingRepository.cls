/**
 * @description: Class to provide stored RulePathFieldSetting__c collections
 * @author: Guilherme Zwipp
 */
public virtual class BR_RulePathFieldSettingRepository extends AbstractRepository {

    private static BR_RulePathFieldSettingRepository instance;

    public static BR_RulePathFieldSettingRepository getInstance() {
        if ( instance == null ) instance = new BR_RulePathFieldSettingRepository();
        return instance;
    }

    protected BR_RulePathFieldSettingRepository() {}
    
    public virtual List<RulePathFieldSetting__c> findByObjectNames( List<String> objectNames ) {
        return [
            SELECT
                Id
                , Name
                , ObjectAPIName__c
            FROM
                RulePathFieldSetting__c
            WHERE
                ObjectAPIName__c IN :objectNames
        ];
    }

    @TestVisible
    private static void setMock( BR_RulePathFieldSettingRepository mockInstance ) {
        instance = mockInstance;
    }

}