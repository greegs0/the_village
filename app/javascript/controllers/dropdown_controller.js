import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    // Wait for next tick to ensure DOM is ready
    setTimeout(() => {
      this.initDropdown()
    }, 0)
  }

  initDropdown() {
    const toggleEl = this.hasToggleTarget ? this.toggleTarget : this.element.querySelector('[data-bs-toggle="dropdown"]')
    if (toggleEl && !bootstrap.Dropdown.getInstance(toggleEl)) {
      this.dropdown = new bootstrap.Dropdown(toggleEl)
    }
  }

  disconnect() {
    if (this.dropdown) {
      this.dropdown.dispose()
      this.dropdown = null
    }
  }
}
