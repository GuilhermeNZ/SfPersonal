import { LightningElement, api } from 'lwc';

import LightningModal from 'lightning/modal';

export default class PpLoginScreenModal extends LightningModal {
    @api content;

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