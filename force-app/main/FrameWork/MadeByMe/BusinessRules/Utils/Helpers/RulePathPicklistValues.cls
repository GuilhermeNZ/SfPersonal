/**
 * @description: Unique class to storage RulePath__c Picklist Value by Constant Name
 * @author: Guilherme Zwipp
 */
public class RulePathPicklistValues {
    
    public static final Map<String,String> STATUS_BY_CONST = new Map<String,String>{
        'EM_ANALISE' => 'Em Análise',
        'REGRA_ATENDIDA' => 'Regra Atendida',
        'REGRA_NAO_ATENDIDA' => 'Regra nao Atendida',
        'AGUARDANDO_PAGAMENTO' => 'Aguardando Pagamento',
        'EM_APROVACAO' => 'Em Aprovacao',
        'INTEGRATION_ERROR' => 'Erro Integracao',
        'WAITING_INTEGRATION_RETURN' => 'Aguardando Retorno da Integracao',
        'PARTIAL_BILLING_COMPLETED' => 'Faturamento Parcial Realizado',
        'ERROR_EXECUTING_RULE' => 'Erro ao Executar Regra'
    };

}