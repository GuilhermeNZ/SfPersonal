import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';

import getAddressWithIntegrationService from '@salesforce/apex/Aula3Controller.getAddressWithIntegration';
import saveAddressInformationService from '@salesforce/apex/Aula3Controller.saveAddressInformation';
import sendEmailError from '@salesforce/apex/Aula3Controller.sendEmailError';

import LOADING from '@salesforce/label/c.Loading';

import userId from '@salesforce/user/Id';

const ACCOUNT_FIELDS = [
    'Account.Id',
    'Account.BillingCity',
    'Account.BillingCountry',
    'Account.BillingNumber__c',
    'Account.BillingPostalCode',
    'Account.BillingState',
    'Account.BillingStreet'
]

const USER_FIELDS = [
    'User.Name'
]

export default class Aula3 extends LightningElement {

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

    @track error = [];
    @track userInfo;
    @track showError = false;
    @track showMap = false;
    @track isLoaded = true;
    @track isLoading = false;
    @track loadingScreenMessage = LOADING;

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

    @wire(getRecord, { recordId: userId, fields: USER_FIELDS}) 
    currentUserInfo({error, data}) {
        if (data) {
            this.userInfo = data;
            console.log('this.userInfo '+JSON.stringify(this.userInfo));
        } else if (error) {
            this.error = error ;
        }
    }

    handleChange( event ) {
        this.enrichAddressFields( event.detail.value, event.target.dataset.field );
    }

    enrichAddressFields( fieldValue, fieldName ) {
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

        if( this.verifyIsNull( this.addressInformations.cep ) || this.verifyIsNull( this.addressInformations.numero ) ) {
            this.showToastEvent('Campos Faltantes', 'Necessário o preenchimento de todos os campos obrigatórios!' , 'error');
            return;
        }

        this.saveAddressInformation(this.recordId, this.addressInformations);
        this.showMap = true;
    }

    handleOnBlurCEP() {
        this.getAddressWithIntegration(this.addressInformations.cep);
        this.isLoading = true;
        this.isLoaded = false;
    }

    saveAddressInformation(accountId, addressInformations){
        saveAddressInformationService({accountId, addressInformations})
        .then(result => {
            if( result != "" && !result.erro ){
                this.showToastEvent('Sucesso', 'Endereço de conta atualizado!', 'success');
                // window.location.reload( true );
            }else{
                this.showToastEvent('Error', 'Não foi possível salvar o novo endereço dessa conta, confira os dados', 'error');
            }
        })
        .catch(error => {
            this.showToastEvent('Error', 'Erro na execução de salvar a conta', 'error');
            console.log("Erro na execução de salvar a conta, error: ",  error );
        })
    }

    getAddressWithIntegration(cep) {
        getAddressWithIntegrationService({cep})
        .then(result => {
            console.log('result '+JSON.stringify(result));
            console.log('verification '+JSON.stringify(result == {}));//Ou poderia ser com o JSON.stringify ou o object.keys
            if( result != "" && Object.keys(result).length !== 0 && !result.erro ){
                this.clear();
                this.addressInformations = this.enricheAddressWithIntegration(result);
                this.finishLoading();
                this.showToastEvent('Sucesso', 'CEP encontrado!', 'success');
            }else{
                this.clear();
                this.finishLoading();
                this.showToastEvent('Error', 'Por favor, verifique se o CEP colocado é um CEP válido', 'error');
            }
        })
        .catch(error => {
            this.clear();
            this.finishLoading();
            this.showToastEvent('Error', 'Falha na executação da integração viaCEP', 'error');
            console.log('Message '+error.message);
            console.log('name '+error.name);
            console.log('stack '+error.stack);
            console.log('track '+error.track);
            console.log("Erro na execução da integração viaCEP, error: ",  error.message );
            let errorMessage = 'Erro LWC aula3-getAddressWithIntegration | Messagem: ' + error.message + ' | ' + ' Usuário: ' + this.userInfo.fields.Name.value;
            this.showError = true;
            if(this.showError){
                this.sendEmailError(JSON.stringify(errorMessage));
            }
            this.error.push(error.message);
            console.log('error in aula '+JSON.stringify(this.error));
        })
    }

    sendEmailError(errorMessage){
        sendEmailError({errorMessage})
        .then(result => {
            console.log('result sendEmailError '+JSON.stringify(result));
        })
        .catch(error => {
            console.log("Erro na execução sendEmailError: ",  error.message );
        })
    }
        

    enricheAddressWithIntegration(result){
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

    finishLoading(){
        this.isLoaded = true;
        this.isLoading = false;
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

}