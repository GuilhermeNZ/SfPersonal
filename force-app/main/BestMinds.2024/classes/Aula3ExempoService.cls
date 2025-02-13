public with sharing class Aula3ExempoService {

    @AuraEnabled
    public static CEPObjTO getAddressWithIntegration ( String CEP ) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        try {
            request.setEndpoint('https://viacep.com.br/ws/'+ CEP +'/json/');
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');

            HttpResponse response = http.send(request);
            CEPObjTO cepResposta = (CEPObjTO)JSON.deserialize(response.getBody(), CEPObjTO.class);

            if(response.getStatusCode() == 200) {
                return cepResposta;
            } else {
                return null;
            }
        } catch (Exception ex){
            System.debug('Erro ao obter os dados da integração ViaCEP: '+ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static Boolean saveAddressInformation(Id accountId, CEPObjTO addressInformations){
        try{

            AccountDAO accountDAO = new AccountDAO();

            Account account = accountDAO.getAccountById(accountId);

            account.BillingCity = addressInformations.cidade;
            account.BillingCountry = addressInformations.bairro;
            account.BillingPostalCode = addressInformations.cep;
            account.BillingState = addressInformations.estado;
            account.BillingStreet = addressInformations.logradouro;
            account.BillingNumber__c = addressInformations.numero;

            update account;

            return true;
        }catch (Exception e){
            System.debug(e.getMessage());
            return false;
        }
    }

    public class CEPObjTO{
        @AuraEnabled public String cep { get; set; }
        @AuraEnabled public String logradouro { get; set; }
        @AuraEnabled public String bairro { get; set; }
        @AuraEnabled public String cidade { get; set; }
        @AuraEnabled public String estado { get; set; }
        @AuraEnabled public String numero { get; set; }
    }
}