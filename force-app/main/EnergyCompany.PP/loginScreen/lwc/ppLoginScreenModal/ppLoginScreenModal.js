import { LightningElement, track } from 'lwc';
import illustration from '@salesforce/resourceUrl/energyLoginImage';

import LightningModal from 'lightning/modal';

export default class PpLoginScreenModal extends LightningModal {
    imageUrl = illustration;

    @track email = '';
    @track password = '';

    handleEmailChange(event) {
        this.email = event.target.value;
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
}