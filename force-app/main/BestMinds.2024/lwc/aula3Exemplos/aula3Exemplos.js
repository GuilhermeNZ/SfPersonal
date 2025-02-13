import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import searchAccountByCEP from '@salesforce/apex/Aula3ExemploController.searchAccountByCEP';
import saveAddressInformation from '@salesforce/apex/Aula3ExemploController.saveAddressInformation';
import getAddressWithIntegration from '@salesforce/apex/Aula3Controller.getAddressWithIntegration';

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

export default class Aula3Exemplos extends LightningElement {

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

    saveAddressInformation(accountId, addressInformation){
        saveAddressInformation({accountId: accountId, addressInformations: addressInformation})
        .then(result => {
            if(result == true){
                window.location.reload( true );
                console.log('Atualizou a conta '+JSON.stringify(result));
            }else{
                this.showToastEvent('Erro', 'Não atualizou a conta' , 'error');
            }
        })
        .catch(error => {
            console.log('Não atualizou a conta '+error);
        })
    }

    searchAccountByCEP(accountCEP){
        searchAccountByCEP({cep:accountCEP})
        .then(result => {
            console.log('resultado do método do apex '+JSON.stringify(result));
        })
        .catch(error => {
            console.log('deu algo um erro '+error);
        })
    }

    getAddressWithIntegration(cep){
        getAddressWithIntegration({cep: cep})
        .then(result => {
            console.log('resultado do método da integração via CEP '+JSON.stringify(result));
            this.addressInformations = this.enricheAddressWitIntegration(result);
            console.log('addressInformation depois da integração '+JSON.stringify(this.addressInformations));
        })
        .catch(error => {
            console.log('deu algo um erro na integração via CEP '+error);
        })
    }

    enricheAddressWitIntegration(result){
        let addressInformation = {};

        addressInformation.cep = result.cep;
        addressInformation.estado = result.uf;
        addressInformation.bairro = result.bairro;
        addressInformation.cidade = result.localidade;
        addressInformation.logradouro = result.logradouro;
        addressInformation.numero = this.addressInformations.numero;
        addressInformation.erro = result.erro;

        return addressInformation;
    }

    handleChange( event ) {
        let fieldName = event.target.dataset.field;
        let fieldValue = event.detail.value;

        if( fieldName == 'Cep' ) {
            let cepRegex = fieldValue.replace( /\D+/g, '' ).match( /(\d{0,5})(\d{0,3})/ );
            fieldValue = cepRegex[1] + ( cepRegex[2] ? '-' + cepRegex[2] : '' );
            this.addressInformations.cep = fieldValue;
        }else if( fieldName == 'Rua' ) {
            this.addressInformations.logradouro = fieldValue;
        }else if( fieldName == 'Bairro' ) {
            this.addressInformations.bairro = fieldValue;
        }else if( fieldName == 'Cidade' ) {
            this.addressInformations.cidade = fieldValue;
        }else if( fieldName == 'Estado' ) {
            this.addressInformations.estado = fieldValue;
        }else if( fieldName == 'Numero' ) {
            let numberRegex = fieldValue.replace( /[^0-9-]/g, '' );
            this.addressInformations.numero = numberRegex;
            event.target.value = this.addressInformations.numero;
        }else{
            console.error( 'Campo não existe!' );
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
        try{
            if( this.verifyIsNull( this.addressInformations.cep ) || this.verifyIsNull( this.addressInformations.numero ) ) {
                this.showToastEvent('Campos Faltantes', 'Necessário o preenchimento de todos os campos obrigatórios!' , 'error');
                return;
            }

            if( this.addressInformations.cep.length != 9 ) {
                this.showToastEvent('Formatação do CEP', 'CEP inserido está inválido!' , 'error');
                return;
            }

            console.log('accountId '+JSON.stringify(this.recordId));
            console.log('addressInformation completo '+JSON.stringify(this.addressInformations));
            this.getAddressWithIntegration(this.addressInformations.cep);
            this.saveAddressInformation(this.recordId, this.addressInformations);
            
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