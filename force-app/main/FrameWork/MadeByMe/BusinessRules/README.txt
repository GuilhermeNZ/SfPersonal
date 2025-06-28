Tag:
    //Working, is proccess dont finished yet

    Automated process to enrich RulePathSettings__mdt with new fields to query
        New object do storage the fields when RuleKey updated - COMPLETED
        Trigger before to validate field entered in the query, return error if dont exist - COMPLETED 50%
        Possible to delete fields in query
        *Resolution: BusinessRules/BusinessRulesSettings


    Definir alguns campos para atualizar do objeto principal dinamicamente
        Inside businessRulesPath, make another object to define the updates
        Inside BusinessRulesSettings, make the same thing


    Screen flow to show the rules in the object layout

    BusinessRulesSettingFinder
        Método para buscar por lista de objetos - FEITO
        Aumentar limite de 49999 registros

    App to manage the frameWork - 30%
        Adiciuonar imagem ao meu app do businessRule
        Criar uma home para o app, com instruçoes, video etc...
        Colocar algumas imagens nos layouts, tornando visualmente mais agradável
        Criar relatórios etc...
        Colocar descriçao nos campos/objetos


    Permission sets to admnin and user, to use the framework
        Admnin - 100% ( If some field are added, dont forget do add here )
        User - 


    Final improvement: Better Logic in BusinessRulesSetting RuleKey__c ( OR, AND, != etc... )
        Create new SObject to keep the fields and value (BusinessRulesRuleKey), and use a field equal flow trigger start