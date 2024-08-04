console.log(">>>> Loading message_form_controller.js");

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("MessageForm controller connected");
    this.sending = false;
    this.button = this.element.querySelector("button[type=submit]");
    this.textarea = this.element.querySelector("textarea");

    this.setMutationObserver();
  }

  submitStart(event) {
    console.log("MessageForm controller submitStart, this.sending:", this.sending);
    if (this.sending) {
      console.log("MessageForm controller submitStart. stop double submission")
      event.detail.formSubmission.stop();
      return;
    }
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

    // setTimeout(
    //   () => {
    //     const messagesListElement = document.querySelector("#messages-list");
    //     messagesListElement.scrollTo({
    //       top: messagesListElement.scrollHeight,
    //       behavior: "smooth"
    //     })
    //   },
    //   500
    // );

    this.button.disabled = false;
    this.textarea.disabled = false;
    this.sending = false;
  }

  setMutationObserver() {
    // React to a new node added to #messages-list element
    const messagesListElement = document.querySelector("#messages-list");
    if (!messagesListElement) {
      return;
    }

    const config = { attributes: true, childList: true, subtree: true };
    const observer = new MutationObserver(this.onMutation);
    observer.observe(messagesListElement, config);
  }

  onMutation(mutations, _observer) {
    for (const mutation of mutations) {
      if (mutation.type === "childList") {
        console.log("A child node has been added or removed.");
        const messagesListElement = document.querySelector("#messages-list");
        messagesListElement.scrollTo({
          top: messagesListElement.scrollHeight,
          behavior: "smooth"
        })
      }
    }
  }

}
