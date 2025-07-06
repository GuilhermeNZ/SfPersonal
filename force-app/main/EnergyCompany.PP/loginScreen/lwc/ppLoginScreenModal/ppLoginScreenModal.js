import LightningModal from 'lightning/modal';
import { wire } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import ENERGY_LOGIN_IMAGE from '@salesforce/resourceUrl/energyLoginImage';
import pageUrl from '@salesforce/resourceUrl/recaptchaV2';

import USER_ID from '@salesforce/user/Id';
import USER_EMAIL_FIELD from "@salesforce/schema/User.Email";
import USER_PASSWORD_FIELD from "@salesforce/schema/User.PP_Password__c";

const PASSWORD_LENGTH = 8;

export default class PpLoginScreenModal extends LightningModal {
    userEmail = '';
    userPassword = '';
    passwordDigited = '';

    errorsMessageWhenRendering = '';
    errorHandledWhenRendering = false;

    navigateTo;

    constructor(){
        super();
        this.navigateTo = pageUrl;
        window.addEventListener("message", this.listenForMessage);//add event listener for message that we post in our recaptchaV2 static resource html file.
    }

    captchaLoaded(event){
        if(event.target.getAttribute('src') == pageUrl){
            console.log('Google reCAPTCHA is loaded.');
        } 
    }

    listenForMessage(message){
        console.log('message : ' + JSON.stringify( message ) );//message.data - The object passed from the other window.
        console.log('message data : ' + message.data);//message.data - The object passed from the other window.
        console.log('message origin : ' + message.origin);//message.origin - The origin of the window that sent the message at the time postMessage was called.
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
        if( this.errorsMessageWhenRendering  && !this.errorHandled ) {
            this.errorHandled = true;
            setTimeout(() => {
                this.handleError( this.errorsMessageWhenRendering );
            }, 0);
        }

        var divElement = this.template.querySelector('div.recaptchaCheckbox');
        //valide values for badge: bottomright bottomleft inline
        var payload = {element: divElement, badge: 'bottomright'};
        document.dispatchEvent(new CustomEvent("grecaptchaRender", {"detail": payload}));
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