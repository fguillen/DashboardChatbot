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

    // Reset whole form but not the model select
    const modelSelectElement = this.element.querySelector("#message_model");
    const modelSelectedIndex = modelSelectElement?.selectedIndex;

    this.element.reset();

    if (modelSelectedIndex) {
      modelSelectElement.selectedIndex = modelSelectedIndex;
    }

    setTimeout(
      () => {
        const messagesListElement = document.querySelector("#messages-list");
        messagesListElement.scrollTo({
          top: messagesListElement.scrollHeight,
          behavior: "smooth"
        })
      },
      500
    );

    this.button.disabled = false;
    this.sending = false;
  }
}
