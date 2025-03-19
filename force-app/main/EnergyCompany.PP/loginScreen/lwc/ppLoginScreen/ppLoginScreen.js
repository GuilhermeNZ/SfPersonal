import { LightningElement } from 'lwc';

import LoginScreenModal from 'c/ppLoginScreenModal';

export default class PpLoginScreen extends LightningElement {

    async connectedCallback() {
        const result = await LoginScreenModal.open({
            disableClose: true,
            size: 'medium',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }

}