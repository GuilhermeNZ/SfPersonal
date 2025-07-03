import LightningModal from 'lightning/modal';
import { track, wire } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import illustration from '@salesforce/resourceUrl/energyLoginImage';

import USER_ID from '@salesforce/user/Id';
import USER_NAME_FIELD from "@salesforce/schema/User.Name";
import USER_EMAIL_FIELD from "@salesforce/schema/User.Email";
import USER_PASSWORD_FIELD from "@salesforce/schema/User.PP_Password__c";

export default class PpLoginScreenModal extends LightningModal {
    @track userName = '';
    @track userEmail = '';
    @track userPassword = '';

    @wire( getRecord, { recordId: USER_ID, fields: [USER_NAME_FIELD, USER_EMAIL_FIELD, USER_PASSWORD_FIELD] } )
    wiredUser( { error, data } ) {
        if( data ) {
            this.userName = getFieldValue( data, USER_NAME_FIELD );
            this.userEmail = getFieldValue( data, USER_EMAIL_FIELD );
            this.userPassword = getFieldValue( data, USER_PASSWORD_FIELD );
        }else if( error ) {
            console.error( 'Error fetching user data:', error );
        }
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
    }

    handleSignIn() {
        // lógica de autenticação ou evento
        console.log('Email:', this.email, 'Password:', this.password);
    }

    handleSignUp() {
        // redirecionamento ou lógica de registro
        console.log('Sign Up clicked');
    }

    handleOkay() {
        this.close('okay');
    }

    handleOptionClick(e) {
        const { target } = e;
        const { id } = target.dataset;
        this.disableClose = false;

        this.close(id);
    }

    imageUrl = illustration;
}