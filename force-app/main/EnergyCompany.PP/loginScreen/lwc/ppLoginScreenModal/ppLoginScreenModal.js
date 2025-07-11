import LightningModal from 'lightning/modal';
import { wire, api } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import ENERGY_LOGIN_IMAGE from '@salesforce/resourceUrl/energyLoginImage';
import pageUrl from '@salesforce/resourceUrl/recaptchaV3';
import isReCAPTCHAValid from '@salesforce/apex/PpLoginScreenModalController.isReCAPTCHAValid';

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

    errorsMessageWhenRendering = '';
    errorHandledWhenRenderingWhenRendering = false;

    constructor(){
        super();
        this.navigateTo = pageUrl;
    }

    captchaLoaded( event ){
        if( event.target.getAttribute( 'src' ).includes( 'recaptchaV3' ) ){

            window.addEventListener("message", (e) => {
                if (e.data.action == "getCAPCAH" && e.data.callCAPTCHAResponse == "NOK"){
                    console.log("Token not obtained!")
                } else if (e.data.action == "getCAPCAH" ) {
                    this.formToken = e.data.callCAPTCHAResponse;
                    isReCAPTCHAValid({tokenFromClient: this.formToken}).then(data => {
                        this.validReCAPTCHA = data;
                    });
                }
            }, false);

        } 
    }

    @wire( getRecord, { recordId: USER_ID, fields: [USER_EMAIL_FIELD, USER_PASSWORD_FIELD] } )
    wiredUser( { error, data } ) {
        if( data ) {
            this.enrichUserData( data );
        }else if( error ) {
            console.error( 'Error fetching user data:', error );
            this.errorsMessageWhenRendering = error.message || 'Unknown error';
        }
    }

    enrichUserData( data ) {
        try{
            this.userEmail = getFieldValue( data, USER_EMAIL_FIELD );
            this.userPassword = getFieldValue( data, USER_PASSWORD_FIELD );
        }catch( error ) {
            console.error( 'Error enriching user data:', error.message );
            this.errorsMessageWhenRendering = 'this.enrichData: ' + error.message;
        }
    }

    renderedCallback() {
        if( this.errorsMessageWhenRendering  && !this.errorHandledWhenRendering ) {
            this.errorHandledWhenRendering = true;
            setTimeout(() => {
                this.handleError( this.errorsMessageWhenRendering );
            }, 0);
        }
    }

    handleSignIn() {
        try{
            const signInInput = this.template.querySelector( 'lightning-input[data-id="passwordInput"]' );
            signInInput.setCustomValidity( this.getSignInPasswordErrors( signInInput.value, this.userPassword ) );
            signInInput.reportValidity();
            if( signInInput.checkValidity() ){
                this.close( 'signIn' );
            }
        }catch( error ) {
            console.error( 'Error in handleSignIn:', error.message );
            this.handleError( 'handleSignIn: ' + error.message );
        }
    }

    getSignInPasswordErrors( passwordDigited, userPassword ) {
        if( !userPassword ) {
            return 'User not registered. Please Sign Up.';
        }

        if( passwordDigited != userPassword ) {
            return 'Password does not match.';
        }

        return '';
    }

    handleSignUp() {
        //
    }

    getSignUpPasswordErrors( passwordDigited ) {
        if( passwordDigited.length < PASSWORD_LENGTH ){
            return 'Password must be at least ' + PASSWORD_LENGTH + ' characters long.';
        }

        return '';
    }

    handleError( errorMessage ) {
        this.close( 'An unexpected error occurred. Please contact your system administrator and provide the following error details: ' + errorMessage );
    }

    get passwordLabel(){
        return 'Password (min '+PASSWORD_LENGTH+' character)';
    }

    get energyLoginImage() {
        return ENERGY_LOGIN_IMAGE;
    }

}