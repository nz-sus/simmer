// app/javascript/controllers/masking_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { content: String };

  connect() {
    this.maskContent();
  }

  toggle(event) {
    event.preventDefault();
    if (this.element.textContent === this.contentValue) {
      this.maskContent();
    } else {
      this.showContent();
    }
  }

  maskContent() {
    this.element.textContent = '******';
  }

  showContent() {
    this.element.textContent = this.contentValue;
  }
}
