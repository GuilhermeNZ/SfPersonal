Tag:
    //Working, is proccess dont finished yet

    BusinessRulesSettings
        Trigger before to validate field entered in the query, return error if dont exist - COMPLETED 50% ( Falta campo de relacionamento )
        Possible to delete fields in query
            Create a relation objeto to rulePathSObjectSetting to storage the fields?

    Definir alguns campos para atualizar do objeto principal dinamicamente
        Inside businessRulesPath, make another object to define the updates
        Inside BusinessRulesSettings, make the same thing

    BusinessRulesSettingFinder
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

    Tratativa para nao deixar adicionar campos no RuleKey caso nao esteja no formato campo=valor

    Final improvement: Better Logic in BusinessRulesSetting RuleKey__c ( OR, AND, != etc... )
        Usar classe boolean
        Onde arrumar: BusinessRulesSettingFinder

    Custom Labels to messages


Revision:
    BusinessRulesSettings (100%):
        BusinessRulesSettingHandler -> 100%
        RulePathSObjectSettingUpsertService -> 100%
    Creation (100%):
        RulePathCreatorService -> 100%
        BusinessRulesSettingFinder -> 100%
    Execution (0%):
        Esperar terminar
