import { Controller } from "@hotwired/stimulus"

// data-controller="modal"
export default class extends Controller {
  static targets = ["backdrop", "search"]

  connect() {
    this._prevOverflow = ""
    this.element.dataset.modalConnected = "true"
  }

  open() {
    this._prevOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"

    this.backdropTarget.hidden = false
    this._focusFirstField()
  }

  close() {
    this.backdropTarget.hidden = true
    document.body.style.overflow = this._prevOverflow || ""
    this._clearSearch()
  }

  // Click outside the modal panel closes it
  backdropClose(event) {
    const panel = this._panel()
    if (panel && !panel.contains(event.target)) this.close()
  }

  // ESC key closes it
  escClose(event) {
    if (event.key === "Escape") this.close()
  }

  // Prevent form submission reloads (we'll wire actual search later)
  preventSubmit(event) {
    event.preventDefault()
  }

  _panel() {
    return this.backdropTarget.querySelector(".modal-panel")
  }

  _focusFirstField() {
    // Prefer focusing the search input, else the panel
    if (this.hasSearchTarget) {
      this.searchTarget.focus()
      this.searchTarget.select()
    } else {
      const panel = this._panel()
      if (panel) panel.focus()
    }
  }

  _clearSearch() {
    if (this.hasSearchTarget) this.searchTarget.value = ""
  }
}
