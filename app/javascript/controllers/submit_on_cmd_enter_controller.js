console.log(">>>> Loading submit_on_cmd_enter_controller.js");

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="submit-on-cmd-enter"
export default class extends Controller {
  connect() {
    console.log("submitOnCmdEnter controller connected")
    this.element.addEventListener("keydown", this.captureKey.bind(this));
  }

  captureKey(event) {
    console.log("submitOnCmdEnter controller capture key, event:", event);
    if ((event.metaKey || event.ctrlKey) && event.keyCode == 13) {
      this.submitForm();
    }
  }

  submitForm() {
    console.log("submitOnCmdEnter controller submit");
    this.element.form.requestSubmit();
  }
}
