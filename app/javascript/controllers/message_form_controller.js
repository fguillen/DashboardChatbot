console.log(">>>> Loading message_form_controller.js");

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("MessageForm controller connected")
  }

  submit() {
    console.log("MessageForm controller submit")
    this.element.reset();
    this.element.scrollIntoView()
  }
}
