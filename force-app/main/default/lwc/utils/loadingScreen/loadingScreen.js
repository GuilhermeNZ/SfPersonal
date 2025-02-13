import { LightningElement, api } from 'lwc';

export default class LoadingScreen extends LightningElement {

    @api message;
    @api showDots = false;
    @api zoomLevel = "zoom: 200%";

}