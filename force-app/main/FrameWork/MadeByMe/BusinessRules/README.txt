Tag:
    //Working, is proccess dont finished yet

    Automated process to enrich RulePathSettings__mdt with new fields to query
        New object do storage the fields when RuleKey updated - COMPLETED
        Trigger before to validate field entered in the query, return error if dont exist
        Possible to delete fields in query


    Definir alguns campos para atualizar do objeto principal dinamicamente
        Inside businessRulesPath, make another object to define the updates
        When one field in excluded, remove from the setting too


    Screen flow to show the rules in the object layout


    App to manage the frameWork


    Permission sets to admnin and user, to use the framework


    Final improvement: Better Logic in BusinessRulesSetting RuleKey__c ( OR, AND, != etc... )
        Create new SObject to keep the fields and value (BusinessRulesRuleKey), and use a field equal flow trigger start