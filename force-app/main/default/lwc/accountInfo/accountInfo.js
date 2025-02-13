import { LightningElement, track } from 'lwc';

export default class AccountInfo extends LightningElement {

    @track active = [];
    @track account = {
        FirstName:"Felizberto",
        LastName:"SA",
        CPF:"000.000.000-00",
        RG:"00.000.000-0",
        PassportNumber:1234,
        BirthDate:"2005-03-07",
        ClientType:"Sales Type",
        SalesDepartment:"Gas, Oil",
        BuyerRating:"Classificação 1",
        Contacts:[
            {Type:"Pessoal", Numero:"(11) 20001-0000"},
            {Type:"Casa", Numero:"4001-7800"},
            {Type:"Trabalho", Numero:"9880-1020"}
        ]
    }

}