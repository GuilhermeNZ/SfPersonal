import LightningModal from 'lightning/modal';
import { wire } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import illustration from '@salesforce/resourceUrl/energyLoginImage';

import USER_ID from '@salesforce/user/Id';
import USER_EMAIL_FIELD from "@salesforce/schema/User.Email";
import USER_PASSWORD_FIELD from "@salesforce/schema/User.PP_Password__c";

const PASSWORD_LENGTH = 8;

export default class PpLoginScreenModal extends LightningModal {
    userEmail = '';
    userPassword = '';

    passwordDigited = '';

    @wire( getRecord, { recordId: USER_ID, fields: [USER_EMAIL_FIELD, USER_PASSWORD_FIELD] } )
    wiredUser( { error, data } ) {
        if( data ) {
            this.userEmail = getFieldValue( data, USER_EMAIL_FIELD );
            this.userPassword = getFieldValue( data, USER_PASSWORD_FIELD );
        }else if( error ) {
            console.error( 'Error fetching user data:', error );
        }
    }

    handlePasswordChange(event) {
        this.passwordDigited = event.target.value;
    }

    handleSignIn() {
        const signInInput = this.template.querySelector( 'lightning-input[data-id="passwordInput"]' );
        signInInput.setCustomValidity( this.getSignInPasswordErrors( this.passwordDigited, this.userPassword ) );
        signInInput.reportValidity();

        // lógica de autenticação ou evento
        console.log('Email:', this.email, 'Password:', this.password);
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

    handleOkay() {
        this.close('okay');
    }

    get passwordLabel(){
        return 'Password (min '+PASSWORD_LENGTH+' character)';
    }

    imageUrl = illustration;
}