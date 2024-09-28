// app/javascript/controllers/bulk_import_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["fileInput", "fileList"]

  connect() {
    console.log("Bulk import controller connected")
    this.fileInputTarget.addEventListener("change", this.handleFiles.bind(this))
  }

  handleFiles(event) {
    const files = event.target.files
    this.fileListTarget.innerHTML = ""

    Array.from(files).forEach((file, index) => {
      const li = document.createElement("li")
      li.textContent = `Uploading ${file.name}...`
      this.fileListTarget.appendChild(li)
      this.uploadFile(file, li)
    })
  }

  uploadFile(file, listItem) {
    const formData = new FormData()
    formData.append("gitleaks_json", file)
    //append the filename to the formData as data_set[name]
    formData.append("data_set[name]", file.name)

    fetch("/api/internal/data_sets", {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").getAttribute("content")
      }
    })
      .then(response => response.json())
      .then(data => {
        if (data.errors) {
          listItem.textContent = `Failed to upload ${file.name}: ${data.errors.join(", ")}`
        } else {
          listItem.textContent = `Successfully uploaded ${file.name}`
        }
      })
      .catch(error => {
        listItem.textContent = `Failed to upload ${file.name}: ${error.message}`
      })
  }
}
