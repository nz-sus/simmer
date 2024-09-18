// In your Stimulus controller (drilldown_controller.js)
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  // support container-targets
  static targets = ["container", "icon"]

  toggleContainer(event) {
    event.preventDefault()
    this.containerTarget.classList.toggle("hidden")
    this.toggleIcon(event)
  }
  toggleIcon(event) {    
    this.iconTarget.classList.toggle("fa-chevron-down")
    this.iconTarget.classList.toggle("fa-chevron-right")
  }
  

  toggle(event) {
    event.preventDefault()
    const detailsRow = this.element.nextElementSibling
    detailsRow.classList.toggle("hidden")
    const icon = this.element.querySelector("i.fas")
    icon.classList.toggle("fa-chevron-down")
    icon.classList.toggle("fa-chevron-right")
  }
}
