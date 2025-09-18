import { Controller } from "@hotwired/stimulus"

// data-controller="modal"
export default class extends Controller {
  static targets = ["backdrop"]

  connect() {
    this._prevOverflow = ""
    // Optional: makes it easy to assert the controller is alive
    this.element.dataset.modalConnected = "true"
  }

  open() {
    this._prevOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"

    // Use native boolean attribute, not a CSS class
    this.backdropTarget.hidden = false
    this._focusPanel()
  }

  close() {
    this.backdropTarget.hidden = true
    document.body.style.overflow = this._prevOverflow || ""
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

  _panel() {
    return this.backdropTarget.querySelector(".modal-panel")
  }

  _focusPanel() {
    const panel = this._panel()
    if (panel) panel.focus()
  }
}
