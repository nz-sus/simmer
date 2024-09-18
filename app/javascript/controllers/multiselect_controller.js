import { Controller } from "@hotwired/stimulus"
import CableReady from 'cable_ready'


// Connects to data-controller="multiselect"
export default class extends Controller {
  //Set a value to store an array of selected values
  static values = {  selected: Array }
  static targets = [ "checkboxes", "actionMenu", "actionMenuSpacer" ]

  connect() {
    
    console.log("connected multiselect")
  }

  initialize() {
    this.selectedValue = this.selectedValue || []
  }

  // On click, add the value to the selected array if it isn't there.
  // If it is there, remove it.
  toggle(event) {
    let value = event.target.id
    console.log("Toggling value: "+value);

    if (this.selectedValue.includes(value)) {
      this.selectedValue = this.selectedValue.filter((item) => item !== value)
      // Hide the selected icon and show the unselected icon      
      event.target.children[0].classList.remove("hidden")
      event.target.children[1].classList.add("hidden")
    } else {
      this.selectedValue = [...this.selectedValue, value]
      // Hide the unselected icon and show the selected icon
      event.target.children[0].classList.add("hidden")
      event.target.children[1].classList.remove("hidden")
    }
    this.updateActionBar();
  }

  // Check whether there are any selected values, if show, make sure the action menu is displayed
  // If not, hide the action menu
  updateActionBar() {
    if (this.selectedValue.length > 0) {
      this.actionMenuTarget.classList.remove("hidden")    
      this.actionMenuSpacerTarget.classList.add("hidden")  
    } else {
      this.actionMenuTarget.classList.add("hidden")
      this.actionMenuSpacerTarget.classList.remove("hidden")
    }
  }

  // Handle action bar buttons - assign_severity and delete for starters  
  assign_severity(event) {
    event.preventDefault();
    const severityValue = event.currentTarget.dataset.multiselectSeverityValue; // Accessing the corrected data attribute
    
    // Submit the selected items and the severity to the server
    fetch("/gitleaks_results/assign_severities/?gitleaks_result_ids="+this.selectedValue+"&severity="+severityValue)
    .then(r => r.json())
    .then(CableReady.perform) 
    
  }

  add_to_incident(event) {
    console.log("Creating incident for items: "+this.selectedValue);
    // get the selected incident id from nearby select input or null if new incident

  }

  delete(event) {
    // fetch("/alarms/delete_list/?alarm_ids="+this.selectedValue)    
    // .then(r => r.json())
    // .then(CableReady.perform) 
    console.log("Deleting items: "+this.selectedValue)
         
  }


}
