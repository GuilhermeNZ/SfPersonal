import { LightningElement, api, track} from 'lwc';

import INDIFERENTE from '@salesforce/label/c.accountName';

const COLUMNS = [
    { label: 'Nome', fieldName: 'Name' },
    { label: 'Valor', fieldName: 'email'},
    { label: 'Tipo de Campo', fieldName: 'fieldType', type: 'phone' },
];

export default class Aula1Exemplo2 extends LightningElement {

    @api isChecked = false;
    @track aprensentaDiv1 = false;
    @track aprensentaDiv2 = false;
    @track contacts = [
        {Name:"Felizberto", valor:"teste1@everymind.com.br", fieldType:"text"},
        {Name:"Joao", valor:"teste2@everymind.com.br", fieldType:"email"},
        {Name:"Guilherme", valor:"teste3@everymind.com.br", fieldType:"email"}
    ];

    connectedCallback(){

        this.aprensentaDiv1 = true;
        this.aprensentaDiv2 = true;
        this.isChecked = true;

    }
    columns = COLUMNS
    labelAccount = INDIFERENTE
}