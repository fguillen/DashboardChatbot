console.log(">>>> Loading message_form_controller.js");

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("MessageForm controller connected");
    this.sending = false;
    this.button = this.element.querySelector("button[type=submit]");
  }

  submitStart(event) {
    console.log("MessageForm controller submitStart, this.sending:", this.sending);
    if (this.sending) {
      console.log("MessageForm controller submitStart. stop double submission")
      event.detail.formSubmission.stop();
      return;
    }
    this.button.disabled = true;
    this.sending = true;
  }

  submitEnd() {
    console.log("MessageForm controller submitEnd, this.sending:", this.sending);
    this.element.reset();
    this.element.scrollIntoView();
    this.button.disabled = false;
    this.sending = false;
  }
}
