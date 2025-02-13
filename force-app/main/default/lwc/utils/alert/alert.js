/**
 * @author henriquebustillos
 */
import { api, LightningElement, track } from 'lwc';

const ALERT_STYLES = {
  // standard: {
  //   notify: "slds-notify slds-notify_alert",
  //   icon: {
  //     span: "slds-icon_container slds-icon-utility-user slds-m-right_x-small slds-m-vertical_x-small",
  //     svg: "/apexpages/slds/latest/assets/icons/utility-sprite/svg/symbols.svg#user",
  //     description: ""
  //   }
  // },
  warning: {
    notify: "slds-box slds-theme_shade slds-theme_alert-texture slds-grid slds-gutters slds-m-horizontal_xxx-small yellow-warning-bg",
    icon: {
      color: "black-icon",
      name: "utility:warning",
      description: "Alerta"
    }
  },
  error: {
    notify: "slds-box slds-theme_shade slds-theme_alert-texture slds-grid slds-gutters slds-m-horizontal_xxx-small red-error-bg",
    icon: {
      color: "white-icon",
      name: "utility:error",
      description: "Erro"
    }
  },
  offline: {}
};

export default class Alert extends LightningElement {

  @api state = "standard";

  @api title;

  @api message;

  @api action = null;

  @api titlealert = "slds-text-heading_small wrapped-content";

  @api titlecss = '';

  @api hiddeIcon = false;

  @api showonlytitle = false;

  @api notifyStyle = '';

  @api
  get closeable() {
    return this._closeable;
  }
  set closeable(closeable) {
    this._closeable = closeable !== false;
  }

  @track hasSlot = true;

  renderedCallback() {
    const slot = this.template.querySelector("slot");
    if (slot && slot.assignedNodes().length === 0) {
      this.hasSlot = false;
    }
  }

  closeQuickAction() {
    this.dispatchEvent(new CloseActionScreenEvent());
  }

  get style() {
    if( this.notifyStyle != '' ) {
      ALERT_STYLES[this.state].notify = this.notifyStyle;
    }

    return ALERT_STYLES[this.state];
  }
}