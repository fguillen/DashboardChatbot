console.log(">>>> Loading conversation_messages_list_controller.js");

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="conversation-messages-list"
export default class extends Controller {
  connect() {
    console.log(">>>> ConversationMessagesList controller connected");
    this.setMutationObserver();
  }

  setMutationObserver() {
    const config = { attributes: true, childList: true, subtree: true };
    const observer = new MutationObserver(this.onMutation.bind(this));
    observer.observe(this.element, config);
  }

  onMutation(mutations, _observer) {
    for (const mutation of mutations) {
      if (mutation.type === "childList") {
        console.log("A child node has been added or removed.");
        const messagesListElement = document.querySelector("#messages-list");
        this.element.scrollTo({
          top: messagesListElement.scrollHeight,
          behavior: "smooth"
        })
      }
    }
  }
}
