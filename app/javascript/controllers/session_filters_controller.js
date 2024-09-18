import { Controller } from "@hotwired/stimulus";
import { post } from "@rails/request.js";
import CableReady from 'cable_ready'


export default class extends Controller {
  static targets = ["filter", "resultsTable"];

  connect() {
    console.log("Connected to the session-filters controller");    
  }

  addFilter(event) {
    // get filterType from parent element's session-filters-type-value attribute
    const filterType = event.target.dataset.sessionFiltersTypeValue;
    const filterValue = event.target.value;    
    //Replace with a fetch request to update the filters to the update_filters
    
    const path = "/gitleaks_results/update_filters_g";
    const params = new URLSearchParams({ add: JSON.stringify({ [filterType]: filterValue }) }).toString();
    const fullPath = `${path}?${params}`;

    fetch(fullPath, {
      method: "GET",
      headers: { "Content-Type": "application/json" }
    }).then(response => {
      if (response.ok && response.headers.get("Content-Type").includes("text/vnd.cable-ready.json")) {
        response.json().then((operations) => {
          CableReady.perform(operations);
        });
      } else {
        // Handle other response types or errors
      }
    });
  }
  

  removeFilter(event) {
    const filterType = event.target.dataset.filterType;
    const filterValue = event.target.dataset.filterValue;

    const path = "/gitleaks_results/update_filters_g";
    const params = new URLSearchParams({ remove: JSON.stringify({ [filterType]: filterValue }) }).toString();
    const fullPath = `${path}?${params}`;

    fetch(fullPath, {
      method: "GET",
      headers: { "Content-Type": "application/json" }
    }).then(response => {
      if (response.ok && response.headers.get("Content-Type").includes("text/vnd.cable-ready.json")) {
        response.json().then((operations) => {
          CableReady.perform(operations);
        });
      } else {
        // Handle other response types or errors
      }
    });
  }
}
