import { LightningElement, track, wire } from 'lwc';
import HideLightningHeader from '@salesforce/resourceUrl/HideLightningHeader';
import { loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

import sendFileToInsertService from '@salesforce/apex/CSVFileReadLWCController.sendFileToInsert';
import getStaticResourcesService from '@salesforce/apex/CSVFileReadLWCController.getStaticResources';
import deleteContentDocumentService from '@salesforce/apex/CSVFileReadLWCController.deleteContentDocument';

import ERROR from '@salesforce/label/c.Error';
import OBJECT from '@salesforce/label/c.Object';
import SUCCESS from '@salesforce/label/c.Success';
import DOWNLOAD from '@salesforce/label/c.Download';
import ARCHIVE_CSV from '@salesforce/label/c.ArchiveCSV';
import LOAD_EXAMPLE from '@salesforce/label/c.LoadExample';
import SELECT_OBJECT from '@salesforce/label/c.SelectObject';
import OBJECT_SENT_QUEUE from '@salesforce/label/c.ObjectSentQueue';
import ERROR_INSTRUCTIONS from '@salesforce/label/c.ErrorInstructions';
import ERROR_INSERT_ARCHIVE from '@salesforce/label/c.ErrorInsertArchive';
import OBJECT_WITHOUT_EXAMPLES from '@salesforce/label/c.ObjectWithoutExamples';
import ERROR_DELETE_ARCHIVE_INVALID from '@salesforce/label/c.ErrorDeleteArchiveInvalid';

import USER_ID from '@salesforce/user/Id';

const USER_FIELDS = ['User.Email'];

const STYLE = {
    NOTIFY_STYLE : "slds-box slds-theme_shade slds-theme_alert-texture slds-grid slds-grid_vertical slds-gutters slds-m-horizontal_xxx-small yellow-warning-bg",
    TITLE_STYLE : "slds-text-heading_medium wrapped-content slds-text-align_center"
}

const ERROR_MESSAGE = [
    {
        "Title":"   O arquivo enviado não está no formato aceito. Se o seu arquivo estiver em formato CSV, siga estes passos:",
        "SubTopics":["1 - Identifique onde está guardado o seu arquivo.","2 - Clique com o botão direito no arquivo e abra-o com o bloco de notas.","3 - Verifique se as colunas estão separadas por ';'.","4 - Se estiverem, contate um administrador. Caso contrário, gere o arquivo novamente."]
    }
];

const TOAST_MESSAGE_BY_ALERT = new Map([
    ["OBJECT_SENT_QUEUE", {"title":SUCCESS, "message":OBJECT_SENT_QUEUE, "variant":"Success", "mode":"dismissable"}],
    ["ERROR_INSERT_ARCHIVE", {"title":ERROR, "message":ERROR_INSERT_ARCHIVE, "variant":"error", "mode":"dismissable"}],
    ["OBJECT_WITHOUT_EXAMPLES", {"title":ERROR, "message":OBJECT_WITHOUT_EXAMPLES, "variant":"error", "mode":"dismissable"}],
    ["ERROR_DELETE_ARCHIVE_INVALID", {"title":ERROR, "message":ERROR_DELETE_ARCHIVE_INVALID, "variant":"error", "mode":"dismissable"}],
])

export default class cSVFileReadLWC extends NavigationMixin(LightningElement) {
    @track objectName;
    @track urlPNG = '';
    @track urlXLSX = '';
    @track userEmail = '';
    @track hasError = false;
    @track viewExamples = false;
    @track staticResources = [];

    connectedCallback() {
        loadStyle(this, HideLightningHeader);
    }

    @wire(getRecord, { recordId: USER_ID, fields: USER_FIELDS })
    User({ error, data }) {
        if (data) {
            console.log( 'User-Email: ' + data.fields.Email.value );
            this.userEmail = data.fields.Email.value;
        } else if (error) {
            console.error('readCSVFileInLWC-getUserDetails: '+error.message);
        }
    }

    comboboxHandleChange(event) {
        this.objectName = event.detail.value;
        let objectNameReplaced = this.objectName.replace('__c', '');
        this.insertExampleChargeInScreen(objectNameReplaced);
    }

    async insertExampleChargeInScreen(objectName){
        this.viewExamples = false;
        await this.getStaticResources(objectName);
        if(!this.verifyNull(this.staticResources)){
            this.viewExamples = true;
            this.getStaticResourceURL(objectName);
        }else{
            this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get("OBJECT_WITHOUT_EXAMPLES"));
        }
    }

    getStaticResourceURL(objectNameReplaced){
        this.urlPNG = '';
        this.urlXLSX = '';
        this.urlPNG = window.location.origin + '/resource/' + objectNameReplaced + 'PNG';
        this.urlXLSX = window.location.origin + '/resource/' + objectNameReplaced + 'XLSX';
    }

    uploadFileHandler(event) {
        const uploadedFiles = event.detail.files;

        console.log( 'contentDocumentId: ' + uploadedFiles[0].documentId );

        sendFileToInsertService({contentDocumentId : uploadedFiles[0].documentId, objectName : this.objectName, userEmail : this.userEmail})
        .then(result => {
            if( result ) {
                this.hasError = false;
                this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get("OBJECT_SENT_QUEUE"));
            }else{
                this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get("ERROR_INSERT_ARCHIVE"));
            }
        })
        .catch(error => {
            this.hasError = true;
            console.error('readCSVFileInLWC-uploadFileHandler: '+error.message);
            TOAST_MESSAGE_BY_ALERT.set(error.body.message, {"title":ERROR, "message":error.body.message, "variant":"error", "mode":"dismissable"})
            this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get(error.body.message));
            this.deleteContentDocument( uploadedFiles[0].documentId );
        })
    }

    deleteContentDocument( contentDocumentId ) {
        deleteContentDocumentService({ contentDocumentId : contentDocumentId})
        .then()
        .catch(error => {
            console.error('readCSVFileInLWC-deleteContentDocument: '+error.message);
            this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get("ERROR_DELETE_ARCHIVE_INVALID"));
        })
    }

    handleDownload(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.urlXLSX
            }
        })
    }

    getStaticResources(objectName){
        return getStaticResourcesService( {objectName : objectName} ).then(result => this.staticResources = result).catch(error => console.error( 'readCSVFileInLWC-deleteContentDocument: '+error ));
    }

    previewHandler() {
        window.open(this.urlPNG, '_blank');
    }

    verifyNull(value){
        if(value == [] || value == '' || value == undefined || value == null || value == {}){
            return true;
        }else{
            return false;
        };
    }

    showToastMessage(object){
        const event = new ShowToastEvent({title: object.title, message: object.message, variant: object.variant, mode: object.mode});
        this.dispatchEvent(event);
    }

    get acceptedCSVFormats() {
        return ['.csv'];
    }

    get acceptedObjects() {
        return [
            { label: 'Account', value: 'Account' }
        ];
    }

    STYLE = STYLE;
    OBJECT = OBJECT;
    DOWNLOAD = DOWNLOAD;
    ARCHIVE_CSV = ARCHIVE_CSV;
    LOAD_EXAMPLE = LOAD_EXAMPLE;
    ERROR_MESSAGE = ERROR_MESSAGE;
    SELECT_OBJECT = SELECT_OBJECT;
    ERROR_INSTRUCTIONS = ERROR_INSTRUCTIONS;

}