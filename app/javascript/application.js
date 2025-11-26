// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import * as bootstrap from "bootstrap"

// Make bootstrap available globally for inline scripts
window.bootstrap = bootstrap

// Initialize all Bootstrap components
function initBootstrapComponents() {
  // Dropdowns
  document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(el => {
    if (!bootstrap.Dropdown.getInstance(el)) {
      new bootstrap.Dropdown(el)
    }
  })
  // Modals
  document.querySelectorAll('[data-bs-toggle="modal"]').forEach(el => {
    const targetSelector = el.getAttribute('data-bs-target')
    if (targetSelector) {
      const modalEl = document.querySelector(targetSelector)
      if (modalEl && !bootstrap.Modal.getInstance(modalEl)) {
        new bootstrap.Modal(modalEl)
      }
    }
  })
}

// Run immediately when script loads
initBootstrapComponents()

// Run on all Turbo events
document.addEventListener('turbo:load', initBootstrapComponents)
document.addEventListener('turbo:render', initBootstrapComponents)
document.addEventListener('turbo:frame-load', initBootstrapComponents)

// Also observe DOM changes to catch dynamically added elements
const observer = new MutationObserver((mutations) => {
  for (const mutation of mutations) {
    if (mutation.addedNodes.length) {
      initBootstrapComponents()
      break
    }
  }
})

observer.observe(document.body, { childList: true, subtree: true })

// Village Alert: Intercept Turbo confirm dialogs
// Remplace les confirm() natifs par Village Alert
document.addEventListener('turbo:before-fetch-request', async (event) => {
  const confirmMessage = event.target.dataset?.turboConfirm
  if (confirmMessage && window.VillageAlert) {
    event.preventDefault()

    const isDanger = confirmMessage.toLowerCase().includes('supprimer') ||
                     confirmMessage.toLowerCase().includes('delete')

    const confirmed = await window.VillageAlert.confirm(confirmMessage, {
      danger: isDanger,
      confirmText: isDanger ? 'Supprimer' : 'Confirmer',
      cancelText: 'Annuler'
    })

    if (confirmed) {
      // Resoumettre sans le confirm
      delete event.target.dataset.turboConfirm
      event.target.requestSubmit ? event.target.requestSubmit() : event.target.submit()
    }
  }
})

// Also intercept link clicks with turbo_confirm
document.addEventListener('turbo:click', async (event) => {
  const link = event.target.closest('a[data-turbo-confirm]')
  if (link && window.VillageAlert) {
    event.preventDefault()

    const confirmMessage = link.dataset.turboConfirm
    const isDanger = confirmMessage.toLowerCase().includes('supprimer') ||
                     confirmMessage.toLowerCase().includes('delete')

    const confirmed = await window.VillageAlert.confirm(confirmMessage, {
      danger: isDanger,
      confirmText: isDanger ? 'Supprimer' : 'Confirmer',
      cancelText: 'Annuler'
    })

    if (confirmed) {
      // Navigate to the link
      delete link.dataset.turboConfirm
      link.click()
    }
  }
})
