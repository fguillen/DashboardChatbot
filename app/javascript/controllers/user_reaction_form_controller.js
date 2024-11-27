console.log(">>>> Loading user_reaction_form_controller.js");

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-reaction-form"
export default class extends Controller {
  connect() {
    console.log("UserReaction controller connected");
    this.button = this.element.querySelector("button[type=submit]");
    this.textarea = this.element.querySelector("textarea");
  }

  submitStart(event) {
    console.log("UserReaction controller submitStart");
    event.preventDefault();
    this.button.disabled = true;
    this.textarea.disabled = true;
  }

  submitEnd() {
    console.log("UserReaction controller submitEnd");

    this.element.reset();

    this.button.disabled = false;
    this.textarea.disabled = false;
  }
}
