console.log(">>>> Loading copy_to_clipboard_controller.js");

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy-to-clipboard"
export default class extends Controller {
  static values = {
    elementToCopy: String
  }

  connect() {
    console.log("CopyToClipboard controller connected, element:", this.element)
  }

  copy() {
    console.log("CopyToClipboard controller copy, this.elementToCopyValue:", this.elementToCopyValue);
    const textToCopy = document.querySelector(this.elementToCopyValue).innerText;
    console.log("CopyToClipboard controller copyToClipboard, textToCopy:", textToCopy);
    navigator.clipboard.writeText(textToCopy);
  }
}
