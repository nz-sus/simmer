import { Controller } from "@hotwired/stimulus";
import { patch } from "@rails/request.js";

export default class extends Controller {
  static values = { url: String };
  static targets = ["tagList", "tagInput"];

  connect() {
   // console.log("Tags controller connected");
  }

  async addTag(event) {
    event.preventDefault();
    const tagName = this.tagInputTarget.value.trim();
    if (!tagName) return;

    // Reject tags with a comma, add a message for the user where the tag would have been
    if (tagName.includes(',')) {
      console.error("Tags cannot contain commas");
      this.tagInputTarget.value = "";
      this.tagInputTarget.placeholder = "Tags cannot contain commas";
      return;
    }

    const response = await patch(this.urlValue, {
      body: JSON.stringify({ add_tag: tagName }),
      contentType: "application/json",
      responseKind: "turbo-stream",
    });

    if (response.ok) {
      this.tagInputTarget.value = "";

      // Create a new tag element
      const newTag = document.createElement('span');
      newTag.classList.add('bg-blue-100', 'text-blue-800', 'text-xs', 'font-semibold', 'mr-2', 'px-2.5', 'py-0.5', 'rounded');
      newTag.textContent = tagName;

      // Create a remove button for the new tag
      const removeButton = document.createElement('button');
      removeButton.setAttribute('type', 'button');
      removeButton.setAttribute('data-action', 'tags#removeTag');
      removeButton.setAttribute('data-tag-name', tagName);
      removeButton.classList.add('text-red-600', 'hover:text-red-900');
      removeButton.textContent = '×';

      // Append the remove button to the new tag element
      newTag.appendChild(removeButton);

      // Append the new tag element to the tag list
      this.tagListTarget.appendChild(newTag);
    } else {
      console.error("Failed to add tag");
    }
  }

  async removeTag(event) {
    event.preventDefault();
    const tagName = event.target.dataset.tagName;

    const response = await patch(this.urlValue, {
      body: JSON.stringify({ remove_tag: tagName }),
      contentType: "application/json",
      responseKind: "json",
    });

    if (response.ok) {
      console.log("Tag removed from list");
      // Find the tag element within the specific row's tag list and remove it
      const tagElement = event.target.closest('span');
      if (tagElement) {
        tagElement.remove();
      }
    } else {
      console.error("Failed to remove tag");
    }
  }
}
