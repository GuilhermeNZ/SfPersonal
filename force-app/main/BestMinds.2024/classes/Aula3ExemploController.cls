public with sharing class Aula3ExemploController {
    @AuraEnabled
    public static Aula3ExempoService.CEPObjTO getAddressWithIntegration(String cep){
        return Aula3ExempoService.getAddressWithIntegration(cep);
    }

    @AuraEnabled
    public static Boolean saveAddressInformation(Id accountId, Aula3ExempoService.CEPObjTO addressInformations){
        Boolean result = Aula3ExempoService.saveAddressInformation(accountId, addressInformations);
        return result;
    }

    @AuraEnabled
    public static Account searchAccountByCEP(String cep){
        AccountDAO accountDAO = new AccountDAO();

        Account account = accountDAO.getAccountByCEP(cep);
        return account;
    }
}