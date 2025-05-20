/**
 * @description: Repository for RulePathSObjectSetting__c Object
 * @author: Guilherme Zwipp
 */
public virtual class RulePathSObjectSettingRepository {

    private static RulePathSObjectSettingRepository instance = null;

    public static RulePathSObjectSettingRepository getInstance() {
        if( instance == null ) instance = new RulePathSObjectSettingRepository();
        return instance;
    }

    protected RulePathSObjectSettingRepository() {}

    public virtual RulePathSObjectSetting__c findByName( String name ) {
        List<RulePathSObjectSetting__c> rulePathSObjectSettings = this.findByNames( new List<String>{name} );
        return rulePathSObjectSettings.isEmpty() ? null : rulePathSObjectSettings[0];
    }

    public virtual List<RulePathSObjectSetting__c> findByNames( List<String> names ) {
        return[
            SELECT
                Id
                , FieldsToUseInQuery__c
            FROM
                RulePathSObjectSetting__c
            WHERE Name IN :names
        ];
    }

}