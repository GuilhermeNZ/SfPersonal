import { LightningElement, api, track } from 'lwc';

export default class Aula4 extends LightningElement {

    @api addressInformations;

    @track mapMarkers = [];

    connectedCallback(){
        console.log('connnected addressInformations intern aula 4 '+JSON.stringify(this.addressInformations));
        this.mapMarkers = [
            {
                location: {
                    City: this.addressInformations.localidade,
                    Country: 'BR',
                    PostalCode: this.addressInformations.cep,
                    State: this.addressInformations.estado,
                    Street: this.addressInformations.logradouro,
                },
            },
        ];
    }
}