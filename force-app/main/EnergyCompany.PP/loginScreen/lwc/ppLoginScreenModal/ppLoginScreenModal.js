import LightningModal from 'lightning/modal';
import { wire, api } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import ENERGY_LOGIN_IMAGE from '@salesforce/resourceUrl/energyLoginImage';
import pageUrl from '@salesforce/resourceUrl/recaptchaV3';

import isReCAPTCHAValid from '@salesforce/apex/PpLoginScreenModalController.isReCAPTCHAValid';
import sendCodeToEmailService from '@salesforce/apex/PpLoginScreenModalController.sendCodeToEmail';

import USER_ID from '@salesforce/user/Id';
import USER_EMAIL_FIELD from "@salesforce/schema/User.Email";
import USER_PASSWORD_FIELD from "@salesforce/schema/User.PP_Password__c";

const PASSWORD_LENGTH = 8;

export default class PpLoginScreenModal extends LightningModal {
    @api formToken;
    @api validReCAPTCHA = false;
    navigateTo;

    userEmail = '';
    userPassword = '';
    passwordDigited = '';

    errorsMessageWhenRendering = '';
    errorHandledWhenRenderingWhenRendering = false;

    isVerificationStep = false;
    codeInputs = new Array(6).fill('');
    codeSentToEmail = '';

    constructor(){
        super();
        this.navigateTo = pageUrl;
    }

    captchaLoaded( event ){
        if ( event.target.getAttribute('src').includes('recaptchaV3') ) {
            window.addEventListener("message", (e) => {
                if ( e.data.action === "getCAPCAH" && e.data.callCAPTCHAResponse === "NOK" ) {
                    console.log("Token not obtained!");
                } else if ( e.data.action === "getCAPCAH" ) {
                    this.formToken = e.data.callCAPTCHAResponse;
                    isReCAPTCHAValid( { tokenFromClient: this.formToken } ).then( data => {
                        this.validReCAPTCHA = data;
                    });
                }
            }, false );
        }
    }

    @wire( getRecord, { recordId: USER_ID, fields: [USER_EMAIL_FIELD, USER_PASSWORD_FIELD] } )
    wiredUser( { error, data } ) {
        if ( data ) {
            this.enrichUserData( data );
        } else if ( error ) {
            console.error( 'Error fetching user data:', error );
            this.errorsMessageWhenRendering = error.message || 'Unknown error';
        }
    }

    enrichUserData( data ) {
        try {
            this.userEmail = getFieldValue( data, USER_EMAIL_FIELD );
            this.userPassword = getFieldValue( data, USER_PASSWORD_FIELD );
        } catch ( error ) {
            console.error( 'Error enriching user data:', error.message );
            this.errorsMessageWhenRendering = 'this.enrichData: ' + error.message;
        }
    }

    renderedCallback() {
        if ( this.errorsMessageWhenRendering && !this.errorHandledWhenRendering ) {
            this.errorHandledWhenRendering = true;
            setTimeout(() => {
                this.handleError( this.errorsMessageWhenRendering );
            }, 0);
        }
    }

    handleSignIn() {
        try {
            const signInInput = this.template.querySelector( 'lightning-input[data-id="passwordInput"]' );
            signInInput.setCustomValidity( this.getSignInPasswordErrors( signInInput.value, this.userPassword ) );
            signInInput.reportValidity();

            if ( signInInput.checkValidity() ) {
                this.close( 'signIn' );
            }
        } catch ( error ) {
            console.error( 'Error in handleSignIn:', error.message );
            this.handleError( 'handleSignIn: ' + error.message );
        }
    }

    getSignInPasswordErrors( passwordDigited, userPassword ) {
        if ( !userPassword ) {
            return 'User not registered. Please Sign Up.';
        }

        if ( passwordDigited !== userPassword ) {
            return 'Password does not match.';
        }

        return '';
    }

    handleSignUp() {
        this.isVerificationStep = true;
        this.sendCodeToEmail();
    }

    sendCodeToEmail() {
        sendCodeToEmailService({ userEmail: this.userEmail })
            .then(( result ) => {
                this.codeSentToEmail = result;
            })
            .catch(error => {
                console.error('Error sending verification code:', error);
                this.handleError('sendCodeToEmail: ' + error.message);
            }
        );
    }

    handleCancel() {
        this.isVerificationStep = false;
        this.codeInputs = new Array(6).fill('');
    }

    handleCodeInput( event ) {
        const value = event.target.value.toUpperCase();
        const index = parseInt( event.target.dataset.id, 10 );

        let newInputs = [...this.codeInputs];
        newInputs[index] = value;
        this.codeInputs = newInputs;

        if( value ) {
            const next = this.template.querySelector( `input[data-id="${index + 1}"]` );
            if ( next ) next.focus();
        }else{
            const prev = this.template.querySelector( `input[data-id="${index - 1}"]` );
            if ( prev ) prev.focus();
        }
        
    }

    handleVerify() {
        const codeEntered = this.codeInputs.join( '' );
        if ( codeEntered.length === 6 && codeEntered == this.codeSentToEmail ) {
            console.log( 'Código informado:', codeEntered );
            this.close( 'verified' );
        } else {
            alert( 'Código inválido. Por favor, verifique o código enviado para o seu e-mail.' );
        }
    }

    handleError( errorMessage ) {
        this.close( 'An unexpected error occurred. Please contact your system administrator and provide the following error details: ' + errorMessage );
    }

    get passwordLabel() {
        return 'Password (min ' + PASSWORD_LENGTH + ' character)';
    }

    get energyLoginImage() {
        return ENERGY_LOGIN_IMAGE;
    }
}
