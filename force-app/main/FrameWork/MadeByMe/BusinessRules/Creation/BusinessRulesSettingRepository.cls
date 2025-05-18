/**
 * @description: Class to provide stored BusinessRulesSetting__c collections
 * @author: Guilherme Zwipp
 */
public virtual class BusinessRulesSettingRepository extends AbstractRepository {
    
    private static BusinessRulesSettingRepository instance = null;

    public static BusinessRulesSettingRepository getInstance() {
        if( instance == null ) instance = new BusinessRulesSettingRepository();
        return instance;
    }

    @TestVisible
    private BusinessRulesSettingRepository(){}

    public virtual List<BusinessRulesSetting__c> findByIsActivatedAndObjectWithPatchsOrderByCreatedDateDESCLimit49999( String objectName ) {
        return [
            SELECT
                Id
                , Name
                , RuleKey__c
                , isActivated__c
                , Object__c
                , (
                    SELECT
                        Id
                        , Name
                        , Sequence__c
                        , isActivated__c
                    FROM
                        BusinessRulesPaths__r
                )
            FROM
                BusinessRulesSetting__c
            WHERE Object__c = :objectName
                AND isActivated__c = true
            ORDER BY CreatedDate DESC
            LIMIT 49999
        ];
    }
}