console.log(">>>> Loading conde_syntax_highlighter_controller.js");

import { Controller } from "@hotwired/stimulus"
// import "prism";

// Connects to data-controller="conde-syntax-highlighter"
export default class extends Controller {
  connect() {
    console.log("CondeSyntaxHighlighter controller connected, element:", this.element)
    // Prism.highlightElement(this.element);
  }
}
