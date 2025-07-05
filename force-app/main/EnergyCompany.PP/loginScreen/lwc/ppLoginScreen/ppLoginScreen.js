import { LightningElement, } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import currentUserHasAutomaticLogin from '@salesforce/apex/PpLoginScreenController.currentUserHasAutomaticLogin';
import createNewSourceIpSession from '@salesforce/apex/PpLoginScreenController.createNewSourceIpSession';

import LoginScreenModal from 'c/ppLoginScreenModal';

export default class PpLoginScreen extends LightningElement {

    connectedCallback() {
        this.currentUserHasAutomaticLoginService();
    }

    currentUserHasAutomaticLoginService() {
        currentUserHasAutomaticLogin()
        .then( ( result ) => {
            if( result ) this.closeScreen();
            else this.openLoginScreenModal();
        } )
        .catch( ( error ) => {
            console.error( 'Error fetching user source IP:', error );
        } );
    }

    async openLoginScreenModal() {
        const result = await LoginScreenModal.open({
            disableClose: false,
            size: 'medium',
            label: 'Login to Energy Company'
        });

        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);

        if( result == 'signIn' ) {
            await this.postSignInActions();
        }else{
            window.history.back();
        }
    }

    async postSignInActions(){
        await this.createNewSourceIpSessionService();
    }

    createNewSourceIpSessionService(){
        return createNewSourceIpSession()
            .then( () => {
                this.postShowToastEvent(
                    'Login Successful',
                    'You are now logged in to the Energy Company portal.',
                    'success',
                    'dismissable'
                );
            } )
            .catch( () => {
                this.postShowToastEvent(
                    'Error',
                    'There was an error creating a new session. Please try again later.',
                    'error',
                    'sticky'
                );
            } );
    }

    postShowToastEvent( title, message, variant, mode ) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: mode
            })
        );
    }

    closeScreen() {
        this.dispatchEvent( new CloseActionScreenEvent() );
    }

}