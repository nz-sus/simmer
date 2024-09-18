import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text"];

  copy(event) {
    event.preventDefault();
    const textToCopy = this.textTarget.textContent;
    navigator.clipboard.writeText(textToCopy)
      .then(() => {
        console.log("Text copied to clipboard");
        const button = this.element.querySelector('.copy-button');
        button.classList.add("copied");
        setTimeout(() => {
          button.classList.remove("copied");
        }, 600); 
      })
      .catch((err) => {
        console.error("Failed to copy text to clipboard", err);
      });
  }
}
