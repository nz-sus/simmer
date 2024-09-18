// app/javascript/controllers/filters_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar", "active", "icon"]

  toggle(event) {
    this.barTarget.classList.toggle("hidden")
    this.changeIcon(this.iconTarget)
  }

  apply(event) {
    event.target.form.requestSubmit()
  }

  changeIcon(icon) {
    icon.classList.toggle("fa-chevron-down")
    icon.classList.toggle("fa-chevron-right")
  }
}
