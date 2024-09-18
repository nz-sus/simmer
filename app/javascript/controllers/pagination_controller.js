import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  loadPage(event) {
    event.preventDefault();
    const url = event.target.href;

    fetch(url)
      .then(response => response.text())
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, "text/html");
        const newContent = doc.querySelector("[data-pagination-target='content']");
        this.element.innerHTML = newContent.innerHTML;
      });
  }
}
