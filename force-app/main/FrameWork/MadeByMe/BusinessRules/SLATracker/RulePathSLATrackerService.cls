/**
 * @description: Class with the responsability to enrich SLATracker fields in RulePath__c SObject
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class RulePathSLATrackerService {

    private static RulePathSLATrackerService instance = null;

    public static RulePathSLATrackerService getInstance() {
        if( instance == null ) instance = new RulePathSLATrackerService();
        return instance;
    }

    private BusinessHoursRepository businessHoursRepositoryInstance;

    private RulePathEnricher enricherInstance;

    private final List<String> startStatus = new List<String>{'Em Análise'};
    private final List<String> finalStatus = new List<String>{'Regra Atendida','Regra nao Atendida','Faturamento Parcial Realizado'};

    private final Map<List<String>,String> statusByIdentifier = new Map<List<String>,String>{
        new List<String>{'Em Aprovacao'} => 'Approval',
        new List<String>{'Erro Integracao'} => 'IntegrationError',
        new List<String>{'Erro ao Executar Regra'} => 'Error',
        new List<String>{'Aguardando Pagamento'} => 'Payment',
        new List<String>{'Aguardando Retorno da Integracao'} => 'WaitingIntegrationReturn'
    };

    private BusinessHours businessHoursDefault;
    private DateTime todayDate;

    private RulePathSLATrackerService() {
        this.businessHoursRepositoryInstance = BusinessHoursRepository.getInstance();

        this.enricherInstance = RulePathEnricher.getInstance();

        this.todayDate = DateTime.now();
    }

    public List<RulePath__c> enrichStatusTrackerFields( List<RulePath__c> rulesPaths, Map<Id,RulePath__c> oldRulesPathById ) {

        this.businessHoursDefault = this.businessHoursRepositoryInstance.findDefault();

        for( RulePath__c rulePath : rulesPaths ) {

            try{
                if( this.startStatus.contains( rulePath.Status__c ) ) {
                    rulePath = this.enricherInstance.withStartDate( rulePath, this.todayDate, '' );
                    continue;
                }
    
                if( oldRulesPathById.containsKey( rulePath.Id ) ){
                    rulePath = this.enrichOldStatusInformations( rulePath, oldRulesPathById.get( rulePath.Id ) );
                }

                if( this.finalStatus.contains( rulePath.Status__c ) ) {
                    rulePath = this.enricherInstance.withEndDateAndSumTimeStamp( rulePath, this.todayDate, '', this.businessHoursDefault );
                    continue;
                }
    
                rulePath = this.enrichNewStatusInformations( rulePath );
    
            }catch( Exception e ){
                rulePath = this.enricherInstance.withTimeStampErrorMessage( rulePath, e.getMessage() );
                continue;
            }

        }

        return rulesPaths;

    }

    private RulePath__c enrichOldStatusInformations( RulePath__c rulePath, RulePath__c oldQuoteRulesPath ) {

        String prefix = this.getDatePrefix( oldQuoteRulesPath );

        if( prefix == '' ) return rulePath;

        rulePath = this.enricherInstance.withEndDateAndSumTimeStamp( rulePath, this.todayDate, prefix, this.businessHoursDefault );

        return rulePath;

    }

    private RulePath__c enrichNewStatusInformations( RulePath__c rulePath ) {

        String prefix = this.getDatePrefix( rulePath );

        if( prefix == '' ) return rulePath;

        rulePath = this.enricherInstance.withStartDate( rulePath, this.todayDate, prefix );

        return rulePath;

    }

    private String getDatePrefix( RulePath__c rulePath ) {
        String prefix = '';

        for( List<String> status : this.statusByIdentifier.keySet() ) {
            if( !status.contains( rulePath.Status__c ) ) continue;

            prefix = this.statusByIdentifier.get( status );
        }

        return prefix;
    }

    @TestVisible
    private void setTodayDate( DateTime todayDateMock ) {
        this.todayDate = todayDateMock;
    }

    @TestVisible
    private void setBusinessHoursRepository( BusinessHoursRepository businessHoursRepositoryMock ){
        this.businessHoursRepositoryInstance = businessHoursRepositoryMock;
    }

}