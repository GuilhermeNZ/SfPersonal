import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';

import TITLE from '@salesforce/label/c.BestMindsTitle';

const ACCOUNT_FIELDS = [
    'Account.Id',
    'Account.BillingCity',
    'Account.BillingCountry',
    'Account.BillingNumber__c',
    'Account.BillingPostalCode',
    'Account.BillingState',
    'Account.BillingStreet'
]

export default class Aula2 extends LightningElement {

    @api recordId;

    @track addressInformations = {
        cep: '',
        logradouro: '',
        bairro: '',
        cidade: '',
        estado: '',
        numero: ''
    }
    @track fieldsPermissionScreen = {
        cepDisabled: false,
        logradouroDisabled: true,
        bairroDisabled: true,
        cidadeDisabled: true,
        estadoDisabled: true,
        numeroDisabled: false
    };

    @wire(getRecord, { recordId: "$recordId", fields: ACCOUNT_FIELDS}) 
    userDetails({error, data}) {
        if (data) {
            this.addressInformations.cep = data.fields.BillingPostalCode.value;
            this.addressInformations.logradouro = data.fields.BillingStreet.value;
            this.addressInformations.bairro = data.fields.BillingCountry.value;
            this.addressInformations.cidade = data.fields.BillingCity.value;
            this.addressInformations.estado = data.fields.BillingState.value;
            this.addressInformations.numero = data.fields.BillingNumber__c.value;
           
        } else if (error) {
            console.log('Error: Não foi possivel coletar informações do usuário!');
        }
    }

    handleChange( event ) {
        let fieldName = event.target.dataset.field;
        let fieldValue = event.detail.value;

        if( fieldName == 'Cep' ) {
            let cepRegex = fieldValue.replace( /\D+/g, '' ).match( /(\d{0,5})(\d{0,3})/ );
            fieldValue = cepRegex[1] + ( cepRegex[2] ? '-' + cepRegex[2] : '' );
            this.addressInformations.cep = fieldValue;
            event.target.value = this.addressInformations.cep;
        }else if( fieldName == 'Numero' ) {
            let numberRegex = fieldValue.replace( /[^0-9-]/g, '' );
            this.addressInformations.numero = numberRegex;
            event.target.value = this.addressInformations.numero;
        }else{
            console.error( 'Campo não possui Formatação' );
        }
    }

    unlockFields(event) {
        this.fieldsPermissionScreen.logradouroDisabled = !event.detail.checked ;
        this.fieldsPermissionScreen.bairroDisabled = !event.detail.checked ;
        this.fieldsPermissionScreen.cidadeDisabled = !event.detail.checked ;
        this.fieldsPermissionScreen.estadoDisabled = !event.detail.checked ;
    }

    clear() {
        this.addressInformations.cep = '';
        this.addressInformations.logradouro = '';
        this.addressInformations.bairro = '';
        this.addressInformations.cidade = '';
        this.addressInformations.estado = '';
        this.addressInformations.numero = '';
    }

    save() {

        if(1 == '1'){
            console.log('dois iguais');
        }
        if('1' === '1'){
            console.log('três iguais');
        }

        try{
            if( this.verifyIsNull( this.addressInformations.cep ) || this.verifyIsNull( this.addressInformations.numero ) ) {
                this.showToastEvent('Campos Faltantes', 'Necessário o preenchimento de todos os campos obrigatórios!' , 'error');
                return;
            }

            if( this.addressInformations.cep.length != 9 ) {
                this.showToastEvent('Formatação do CEP', 'CEP inserido está inválido!' , 'error');
                return;
            }
        
            console.log( 'Salvar' );
            console.log( this.addressInformations.bairro );
            console.log( this.addressInformations.logradouro );
            console.log( this.addressInformations.cep );
            console.log( this.addressInformations.cidade );
            console.log( this.addressInformations.estado );
            console.log( this.addressInformations.numero );
            console.log( this.addressInformations.error.teste ); //Erro

            this.showToastEvent('Sucesso!', 'Dados Salvos com Sucesso!' , 'success');

        }catch( error ) {
            this.showToastEvent( 'Erro!', 'Contate um Administrador!' , 'error' );
            console.error( 'Error!!!: ' + error.message );
        }

    }

    verifyIsNull( value ) {
        return ( value == [] || value == '' || value == undefined || value == null || value == {} );
    }

    showToastEvent(titulo, mensagem, tipo) {
        const event = new ShowToastEvent({
            title: titulo,
            message: mensagem,
            variant: tipo
        });
        this.dispatchEvent(event);
    }

    TITLE = TITLE;

}