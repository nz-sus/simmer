import { Controller } from "@hotwired/stimulus";
import { patch } from "@rails/request.js";

export default class extends Controller {
  static values = { url: String, severity: String, type: String};
  static targets = ["icon"];

  connect() {    
    this.handleEscape = this.handleEscape.bind(this);
  }

  toggleMenu(event) {
    event.preventDefault();
  
    // Check if the menu is already open
    const existingMenu = document.querySelector('.severity-menu');
    if (existingMenu) {
      existingMenu.remove();
      document.removeEventListener('keydown', this.handleEscape);
    } else {
      // Create and position the menu
      const menu = this.renderMenu();
      const { top, left } = event.target.getBoundingClientRect();
      menu.style.position = 'absolute';
      menu.style.top = `${top - menu.offsetHeight}px`; // Position above the clicked item
      menu.style.left = `${left}px`;
      menu.classList.add('severity-menu');
  
      this.element.appendChild(menu);
      document.addEventListener('keydown', this.handleEscape);
    }  
  }

  async updateSeverity(event) {
    const newSeverity = event.currentTarget.dataset.severity;
    const response = await patch(this.urlValue, {
      body: JSON.stringify({ [this.typeValue]: { severity: newSeverity } }),
      contentType: "application/json",
      responseKind: "json",
    });

    if (response.ok) {      
      this.severityValue = newSeverity;
      this.updateIcon();
      const existingMenu = document.querySelector('.severity-menu');
      if (existingMenu) {
        existingMenu.remove();
        document.removeEventListener('keydown', this.handleEscape);
      }
    } else {
      console.error("Failed to update severity");
    }
  }

  renderMenu() {
    console.log("Rendering menu");
    const menu = document.createElement('div');
    menu.classList.add('absolute', 'bg-white', 'shadow-md', 'rounded', 'z-10');
    menu.style.width = '150px';
  
    const severities = [
      { label: 'CRITICAL', iconClass: 'fas fa-exclamation-circle text-red-500' },
      { label: 'HIGH', iconClass: 'fas fa-exclamation-triangle text-orange-500' },
      { label: 'MEDIUM', iconClass: 'fas fa-exclamation text-yellow-500' },
      { label: 'LOW', iconClass: 'fas fa-minus-circle text-blue-500' },
      { label: 'SUSPICIOUS', iconClass: 'fas fa-eye text-purple-500' },
      { label: 'SAFE', iconClass: 'fas fa-check-circle text-green-500' },
      { label: 'UNKNOWN', iconClass: 'fas fa-question-circle text-gray-500' }
    ];
  
    severities.forEach(({ label, iconClass }) => {
      const option = document.createElement('button');
      option.classList.add('flex', 'items-center', 'w-full', 'text-left', 'px-4', 'py-2', 'text-sm', 'hover:bg-gray-100');
      option.setAttribute('data-action', 'severity#updateSeverity');
      option.setAttribute('data-severity', label);
  
      const icon = document.createElement('i');
      icon.className = `${iconClass} mr-2`;
      option.appendChild(icon);
  
      const text = document.createTextNode(label);
      option.appendChild(text);
  
      menu.appendChild(option);
    });
  
    return menu;
  }

  handleEscape(event) {
    if (event.key === 'Escape') {
      const existingMenu = document.querySelector('.severity-menu');
      if (existingMenu) {
        existingMenu.remove();
        document.removeEventListener('keydown', this.handleEscape);
      }
    }
  }

  updateIcon() {
    // Update the icon based on this.severityValue
    switch (this.severityValue) {
      case "CRITICAL":
        this.iconTarget.className = "fas fa-exclamation-circle text-red-500";
        break;
      case "HIGH":
        this.iconTarget.className = "fas fa-exclamation-triangle text-orange-500";
        break;
      case "MEDIUM":
        this.iconTarget.className = "fas fa-exclamation text-yellow-500";
        break;
      case "LOW":
        this.iconTarget.className = "fas fa-minus-circle text-blue-500";
        break;
      case "SUSPICIOUS":
        this.iconTarget.className = "fas fa-eye text-purple-500";
        break;
      case "SAFE":
        this.iconTarget.className = "fas fa-check-circle text-green-500";
        break;
      case "UNKNOWN":
        this.iconTarget.className = "fas fa-question-circle text-gray-500";
        break;
      default:
        this.iconTarget.className = "fas fa-question-circle text-gray-500";
    }
  }
}
