import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notes"
export default class extends Controller {
  static targets = [ "icon" ]
  static values = { 
    id: String,
    type: String // Class name
   }

  initialize() {
    this.isDirty = false;
  }

  connect() {
    
  }

  addNote() {
    //Disable the add note button and show a spinner while the note is being saved.
    const spinner = document.querySelector(".adding_note");
    spinner.classList.remove("hidden");
    //Disable add noto button 
    const addNoteButton = document.querySelector(".add-note");
    addNoteButton.disabled = true;
    addNoteButton.classList.add("disabledButton");
    //change the style of the add-note button
    //Grab the note content from the Trix editor and post it to the server. it'll return the new note as HTML, which we'll append to the notes list.
    const content = this.getTrixEditor().innerHTML.trim();
    fetch(`/notes/${this.typeValue}/${this.idValue}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "text/html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")

      },
      body: JSON.stringify({ content: content })
    }).then(response => {
      //check the response status and append the new note to the list if successful.
      if (response.ok) {
        response.text().then(html => {
          this.isDirty = false;
          //Clear the trix editor
          this.getTrixEditor().editor.loadHTML("");
          this.toggleModal();
          // Don't close the modal after adding a note
          //refresh the page after a note
          location.reload();     
        });
      } else {
        response.text().then(error => {
          //TODO make this more elegant
          alert("Failed to save note: " + error);
        });                
      }
      spinner.classList.add("hidden");
      addNoteButton.classList.remove("disabledButton");
      document.querySelector(".add-note").disabled = false;      
    });
   
  }

  markDirty() {    
    this.isDirty = true

  }

  toggleModal() {
    // Find the single shared modal target for the application
    this.modal = this.getNotesModal();
    // If visible, check if dirty before closing
    if (!this.modal.classList.contains("hidden"))
    {
      if (this.hasTrixContent()) {
        if (!confirm("You have unsaved changes. Are you sure you want to close?")) {
          return;
        }
      }
    } 

    this.modal.classList.toggle("hidden");
    if (!this.modal.classList.contains("hidden")) {
      this.loadContent();
      // Add a listener for escape key to close the modal
      document.addEventListener("keydown", this.escapeListener);      
    } else {
      document.removeEventListener("keydown", this.escapeListener);
    }
  }  

  hasTrixContent() {
    return this.getTrixEditor().editor.getDocument().toString().trim() !== "";
  }

  escapeListener = (event) => {
    if (event.key === "Escape") {
      // Confirm if dirty
      if (this.hasTrixContent()) {
        if (!confirm("You have unsaved changes. Are you sure you want to close?")) {
          return;
        }
      }
      this.modal.classList.add("hidden");
      document.removeEventListener("keydown", this.escapeListener);
      //Clear the modal of everything underneath the top level h3 and replace it's text with Loading...
      this.getNotesModal().querySelectorAll("h3 ~ *").forEach(element => element.remove());
      this.getNotesModal().querySelector("h3").innerText = "Loading...";
      
    } else if ((event.metaKey || event.ctrlKey) && event.key === "Enter") {
      // Trigger a save
      this.addNote();

      
    }
  }

  loadContent() {
    fetch(`/notes/${this.typeValue}/${this.idValue}`, {
      headers: {
        "Accept": "text/html"
      }
    })
    .then(response => response.text())
    .then(html => {
      this.getNotesModal().innerHTML = html;
    });
  }

  getNotesModal() {
    return document.querySelector("#notesModal")
  }

  getTrixEditor() {
    return document.querySelector("trix-editor")
  }

  //In addNote, clear the dirty flag.

}
