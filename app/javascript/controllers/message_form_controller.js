console.log(">>>> Loading message_form_controller.js");

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("MessageForm controller connected");
    this.sending = false;
    this.button = this.element.querySelector("button[type=submit]");
    this.textarea = this.element.querySelector("textarea");
  }

  submitStart(event) {
    console.log("MessageForm controller submitStart, this.sending:", this.sending);
    if (this.sending) {
      console.log("MessageForm controller submitStart. stop double submission")
      event.detail.formSubmission.stop();
      return;
    }
    this.addSubconversationDiv();
    this.button.disabled = true;
    this.textarea.disabled = true;
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

    this.button.disabled = false;
    this.textarea.disabled = false;
    this.sending = false;
  }

  addSubconversationDiv() {
    console.log("addSubconversationDiv");
    const subconversationDiv = document.createElement("div");
    subconversationDiv.classList.add("subconversation");
    document.querySelector("#messages-list").appendChild(subconversationDiv);
  }
}
