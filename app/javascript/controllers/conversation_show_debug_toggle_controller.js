console.log(">>>> Loading conversation_messages_list_controller.js");

import { Controller } from "@hotwired/stimulus"
import Cookies from "js-cookie"

// Connects to data-controller="conversation-show-debug-toggle"
export default class extends Controller {
  static values = { mainDivId: String }

  connect() {
    console.log(">>>> ConversationShowDebugToggle controller connected");
    this.isEnabled = Cookies.get("conversationShowDebug") == "true";
    this.mainDiv = document.getElementById(this.mainDivIdValue);
    this.setMainDivClass();
    this.setToggleValue();

    this.element.addEventListener("change", this.onChange.bind(this));
  }

  onChange() {
    this.isEnabled = this.element.checked;
    Cookies.set("conversationShowDebug", this.isEnabled);
    this.setMainDivClass();
  }

  setMainDivClass() {
    console.log("ConversationShowDebugToggle.setMainDivClass, this.isEnabled:", this.isEnabled);

    if (this.isEnabled) {
      this.mainDiv.classList.add("show-debug");
    } else {
      this.mainDiv.classList.remove("show-debug");
    }
  }

  setToggleValue() {
    console.log("ConversationShowDebugToggle.setToggleValue, this.isEnabled:", this.isEnabled);
    this.element.checked = this.isEnabled;
  }
}
