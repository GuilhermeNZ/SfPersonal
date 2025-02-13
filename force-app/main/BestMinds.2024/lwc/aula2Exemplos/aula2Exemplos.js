import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const PI_TESTE = '3,14';

const ACCOUNT_FIELDS = [
    'Account.Name',
    'Account.BillingNumber__c'
]

export default class Aula2Exemplos extends LightningElement {

    //Variáveis publicas
    @api recordId;
    @api objetoQueVeioDeOutraTela;
    @api name;

    //Variáveis rastreaveis ( para utilização iterna )
    @track nome = '';
    @track idade = 0;
    @track casado = true;
    @track casado = ['teste1','teste2'];
    @track addressInformations = {
        cep: '',
        logradouro: '',
        bairro: '',
        cidade: '',
        estado: '',
        numero: ''
    }

    @track inputField = '';

    @track disableField = true;
    @track requiredField = false;

    @wire(getRecord, { recordId: "$recordId", fields: ACCOUNT_FIELDS})
    accountDetails({error, data}) {
        if( data ) {
            console.log('Number: ' + JSON.stringify( data.fields.BillingNumber__c.value ) );
            console.log('Name: ' + JSON.stringify( data.fields.Name.value ) );
            this.nome = data.fields.Name.value;
            //Lógica para armazenar os campos
        } else {
            //tratativa de erro
            //fecha o lwc
            //mostrar mensgaem de erro
        }
    }

    //Eventos de Ciclo de Vida do LWC
    constructor() {
        super();
        console.log('constructing');
    }

    //async Para definir que é uma função syncrona
    //await serve para ele ter que esperar a execução do método que está em await para ir para o próximo

    async connectedCallback() {
        console.log('connectCallBack');
        let soma = await this.soma( 2, 3 ); //5seg
        console.log('soma: ' + soma );
        this.consoleSemReturn();
    }

    renderedCallback(){
        console.log('renderedCallback');
    }

    errorCallback(){
        console.log('errorCallBack');
    }

    //Funções que são chamadas
    soma( a, b ) {
        console.log('soma');
        let soma = a + b;
        return soma;
    }

    consoleSemReturn(){
        console.log('SemReturn');
    }

    //Eventos de tela
    handleChange( event ){

        try{
            let fieldName = event.target.dataset.label;

            //this.teste.error = 123; //Caso queira que dê erro descomente essa linha

            console.log('####fieldName: ' + fieldName );
            console.log('==========================================');
            console.log('onChange');
            console.log( 'onChange Valor do Campo: ' + JSON.stringify( event.target.value ) );
            console.log('==========================================');
    
            console.log( 'Label: ' + event.target.label );
    
            if( fieldName === 'ZipCode' ) {
                let fieldValue = event.detail.value;
    
                // replace( /\D+/g, '' ) = Está substituindo qualquer letra por ''
                //.match( /(\d{0,5})(\d{0,3})/ ) = "split" mas por contagem de caracteres ( faz uma lista com os caracteres pelo indice )
        
                // fieldValue = 123bacg45678
                let fieldValueSemCaracteres = fieldValue.replace( /\D+/g, '' );
                //fieldValueSemCaracteres = 12345678
        
                let cepRegex = fieldValueSemCaracteres.match( /(\d{0,5})(\d{0,3})/ );
                //cepRegex = [ '12345','678'];
        
                //cepRegex[1] = 5 primeiros caracteres = 12345
                //cepRegex[2] = os ultimos 3 caracteres = 678
        
                fieldValue = cepRegex[1] + ( cepRegex[2] ? '-' + cepRegex[2] : '' );
                //fieldValue = 12345-678
        
                event.target.value = fieldValue;
            }
        }catch( error ) {
            const event = new ShowToastEvent({
                title: 'Error D:',
                message:
                    'Deu ruim ai, chama o ADM',
                variant: 'error'
            });
            this.dispatchEvent(event);
            console.error( 'HandleChange-Error: ' + error.message );
        }

    }

    handleBlur( event ){
        console.log('Tirou meu foco :/');
        console.log( 'Valor do Campo: ' + JSON.stringify( event.target.value ) );
    }

    handleClick( event ){
        console.log('Me clicou :)');
        console.log( 'Valor do Campo: ' + JSON.stringify( event.target.value ) );
    }

    handleClickSave(){
        this.showToast();
    }

    //Mensagem de sucesso no topo da página ( OBS: n esquecer de importar a "biblioteca": ShowToastEvent )
    showToast() {
        const event = new ShowToastEvent({
            title: 'Sucesso!!!!',
            message: 'Sucesso!! Aprendi a fazer um toastEvent!.',
            variant: 'success'
        });
        this.dispatchEvent(event);
    }

    handleFocus( event ){
        console.log('Ganhei foco :D');
        console.log( 'Valor do Campo: ' + JSON.stringify( event.target.value ) );
    }

    handleKeyDown( event ){
        console.log('==========================================');
        console.log('KeyDown :o');
        console.log( 'key down Valor do Campo: ' + JSON.stringify( event.target.value ) );
        console.log('==========================================');
    }
    
    handleManualEdition( event ){
        console.log('Clicou na edição manual');
        if( event.target.checked == false ) {
            console.log('é falso :(');
        }else{
            console.log('é true :D');
        }

        console.log('This.nome: ' + this.nome );

        this.disableField = !event.target.checked;
        this.requiredField = event.target.checked;
    }

}