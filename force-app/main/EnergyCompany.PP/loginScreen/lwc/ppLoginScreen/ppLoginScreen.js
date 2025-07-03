import { LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

import currentUserHasAutomaticLogin from '@salesforce/apex/PpLoginScreenController.currentUserHasAutomaticLogin';

import LoginScreenModal from 'c/ppLoginScreenModal';

export default class PpLoginScreen extends LightningElement {

    connectedCallback() {
        this.currentUserHasAutomaticLoginService();
    }

    currentUserHasAutomaticLoginService() {
        currentUserHasAutomaticLogin()
        .then( ( result ) => {
            if( result ) this.closeAction();
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
        });

        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }

    closeAction() {
        this.dispatchEvent( new CloseActionScreenEvent() );
    }

}