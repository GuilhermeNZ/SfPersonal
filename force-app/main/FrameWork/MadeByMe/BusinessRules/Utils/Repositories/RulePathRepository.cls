/**
 * @description: Repository for RulePath__c Object
 * @author: Guilherme Zwipp
 */
public virtual with sharing class RulePathRepository extends AbstractRepository {
    
    private static RulePathRepository instance = null;

    public static RulePathRepository getInstance() {
        if( instance == null ) instance = new RulePathRepository();
        return instance;
    }

    protected RulePathRepository(){}

    public virtual List<RulePath__c> findByIds( List<String> ids ) {
        return [
            SELECT
                Id
                , SObjectId__c
            FROM
                RulePath__c
            WHERE Id IN :ids
        ];
    }

    public virtual List<RulePath__c> findBySObjectIdsAndClassNameAndIsDisabled( List<String> sObjectIds, String className, Boolean isDisabled ) {
        return [
            SELECT
                Id
                , Status__c
                , SObjectId__c
                , Sequence__c
                , isActivated__c
            FROM
                RulePath__c
            WHERE SObjectId__c IN :sObjectIds
                AND ClassName__c = :className
                AND isDisabled__c = :isDisabled
        ];
    }

    public virtual List<RulePath__c> findBySequenceKeysAndIsActiveAndIsDisabled( Set<String> sequenceKeys, Boolean isActivated, Boolean isDisabled ) {
        return [
            SELECT
                Id
                , Status__c
                , SObjectId__c
                , Sequence__c
            FROM
                RulePath__c
            WHERE SequenceKey__c IN :sequenceKeys
                AND isActivated__c = :isActivated
                AND isDisabled__c = :isDisabled
        ];
    }

    public virtual List<RulePath__c> findByClassNamesAndStatusAndIsDisabled( List<String> classNames, String status, Boolean isDisabled ){
        return[
            SELECT
                Id
                , SObjectId__c
                , Status__c
            FROM
                RulePath__c
            WHERE ClassName__c IN :classNames
                AND Status__c = :status
                AND isDisabled__c = :isDisabled
        ];
    }

    public virtual List<RulePath__c> findBySObjectIdsAndIsActiveAndIsDisabled( Set<String> sObjectIds, Boolean isActivated, Boolean isDisabled ){
        return[
            SELECT
                Id
                , SObjectId__c
                , Status__c
                , ExecuteSubRule__c
            FROM
                RulePath__c
            WHERE SObjectId__c IN :sObjectIds
                AND isActivated__c = :isActivated
                AND isDisabled__c = :isDisabled
        ];
    }

    public virtual List<RulePath__c> findBySObjectIdsAndStatusAndIsActivatedAndIsDisabled( Set<String> sObjectIds, String status, Boolean isActivated, Boolean isDisabled ){
        return[
            SELECT
                Id
                , SObjectId__c
                , Status__c
                , isActivated__c
                , Sequence__c
                , ExecuteSubRule__c
            FROM
                RulePath__c
            WHERE SObjectId__c IN :sObjectIds
                AND Status__c = :status
                AND isActivated__c = :isActivated
                AND isDisabled__c = :isDisabled
        ];
    }

}