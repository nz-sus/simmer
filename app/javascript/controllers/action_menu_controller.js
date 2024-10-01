import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container"];
  static values = { repositoryUrl: String };


  toggleMenu(event) {
    event.preventDefault();
    this.containerTarget.classList.toggle("hidden");
  }

  closeMenu(event) {
    this.containerTarget.classList.add("hidden");
  }
  
}
