import { Controller } from "@hotwired/stimulus"

// Village Alert Controller
// Système d'alertes personnalisé avec Village Assistant
//
// Usage:
//   VillageAlert.success("Tâche créée avec succès !")
//   VillageAlert.error("Une erreur est survenue")
//   VillageAlert.warning("Attention, cette action est irréversible")
//   VillageAlert.info("Nouvelle fonctionnalité disponible")
//   VillageAlert.confirm("Voulez-vous supprimer cet élément ?", { onConfirm: () => {...}, danger: true })
//   VillageAlert.toast("Modification enregistrée", "success")

export default class extends Controller {
  static targets = ["alert", "message", "status", "actions", "progress", "progressBar", "subtitle", "avatarWrapper"]
  static values = {
    autoHide: { type: Boolean, default: true },
    duration: { type: Number, default: 5000 }
  }

  connect() {
    // Rendre VillageAlert disponible globalement
    window.VillageAlert = {
      success: (message, options = {}) => this.show("success", message, options),
      error: (message, options = {}) => this.show("error", message, options),
      warning: (message, options = {}) => this.show("warning", message, options),
      info: (message, options = {}) => this.show("info", message, options),
      confirm: (message, options = {}) => this.showConfirm(message, options),
      toast: (message, type = "success", options = {}) => this.showToast(message, type, options)
    }

    // Écouter les événements custom pour les flash messages Rails
    document.addEventListener("village-alert:show", (e) => {
      const { type, message, options } = e.detail
      this.show(type, message, options)
    })
  }

  disconnect() {
    if (this.hideTimeout) clearTimeout(this.hideTimeout)
    if (this.closeTimeout) clearTimeout(this.closeTimeout)
    if (this.confirmCloseTimeout) clearTimeout(this.confirmCloseTimeout)
    if (this.progressInterval) clearInterval(this.progressInterval)
  }

  show(type, message, options = {}) {
    const { autoHide = this.autoHideValue, duration = this.durationValue, toast = false } = options

    // Annuler tous les timeouts précédents (important pour éviter qu'un close() précédent ne ferme cette alerte)
    if (this.hideTimeout) clearTimeout(this.hideTimeout)
    if (this.closeTimeout) clearTimeout(this.closeTimeout)
    if (this.confirmCloseTimeout) clearTimeout(this.confirmCloseTimeout)

    // Reset
    this.alertTarget.classList.remove("toast", "closing")
    if (toast) {
      this.alertTarget.classList.add("toast")
    }

    // Set message
    this.messageTarget.textContent = message

    // Set subtitle based on type
    this.subtitleTarget.textContent = this.getSubtitle(type)

    // Set status badge on avatar
    this.statusTarget.className = `village-alert-status ${type}`
    this.statusTarget.innerHTML = this.getStatusIcon(type)

    // Hide actions (not a confirm)
    this.actionsTarget.style.display = "none"

    // Show alert
    this.alertTarget.style.display = "flex"

    // Auto-hide with progress
    if (autoHide) {
      this.startProgress(duration)
      this.hideTimeout = setTimeout(() => this.close(), duration)
    } else {
      this.progressTarget.style.display = "none"
    }
  }

  showConfirm(message, options = {}) {
    const {
      onConfirm = () => {},
      onCancel = () => {},
      confirmText = "Confirmer",
      cancelText = "Annuler",
      danger = false
    } = options

    this.pendingConfirm = onConfirm
    this.pendingCancel = onCancel

    // Reset
    this.alertTarget.classList.remove("toast", "closing")

    // Set message
    this.messageTarget.textContent = message

    // Set subtitle
    this.subtitleTarget.textContent = "vous demande"

    // Set status badge on avatar
    const type = danger ? "warning" : "confirm"
    this.statusTarget.className = `village-alert-status ${type}`
    this.statusTarget.innerHTML = this.getStatusIcon(type)

    // Show actions
    this.actionsTarget.style.display = "flex"

    // Update button texts and style
    const confirmBtn = this.actionsTarget.querySelector(".village-alert-btn-confirm")
    const cancelBtn = this.actionsTarget.querySelector(".village-alert-btn-cancel")
    confirmBtn.textContent = confirmText
    cancelBtn.textContent = cancelText

    if (danger) {
      confirmBtn.classList.add("danger")
    } else {
      confirmBtn.classList.remove("danger")
    }

    // Hide progress for confirm
    this.progressTarget.style.display = "none"

    // Show alert
    this.alertTarget.style.display = "flex"

    // Return a promise for async usage
    return new Promise((resolve) => {
      this.confirmResolve = resolve
    })
  }

  showToast(message, type = "success", options = {}) {
    this.show(type, message, { ...options, toast: true, duration: options.duration || 4000 })
  }

  confirm() {
    if (this.pendingConfirm) {
      this.pendingConfirm()
    }
    if (this.confirmResolve) {
      this.confirmResolve(true)
      this.confirmResolve = null // Éviter les appels multiples
    }
    // Fermer après un micro-délai pour laisser le code appelant afficher une nouvelle alerte
    this.confirmCloseTimeout = setTimeout(() => this.close(), 50)
  }

  cancel() {
    if (this.pendingCancel) {
      this.pendingCancel()
    }
    if (this.confirmResolve) {
      this.confirmResolve(false)
      this.confirmResolve = null // Éviter les appels multiples
    }
    // Fermer après un micro-délai pour laisser le code appelant afficher une nouvelle alerte
    this.confirmCloseTimeout = setTimeout(() => this.close(), 50)
  }

  close() {
    if (this.hideTimeout) clearTimeout(this.hideTimeout)
    if (this.progressInterval) clearInterval(this.progressInterval)

    this.alertTarget.classList.add("closing")

    this.closeTimeout = setTimeout(() => {
      this.alertTarget.style.display = "none"
      this.alertTarget.classList.remove("closing")
      this.progressBarTarget.style.transform = "scaleX(1)"
    }, 200)
  }

  startProgress(duration) {
    this.progressTarget.style.display = "block"
    this.progressBarTarget.style.transform = "scaleX(1)"
    this.progressBarTarget.style.transition = `transform ${duration}ms linear`

    // Force reflow
    this.progressBarTarget.offsetHeight

    this.progressBarTarget.style.transform = "scaleX(0)"
  }

  getSubtitle(type) {
    const subtitles = {
      success: "vous félicite",
      error: "vous alerte",
      warning: "vous prévient",
      info: "vous informe",
      confirm: "vous demande"
    }
    return subtitles[type] || "vous informe"
  }

  getStatusIcon(type) {
    const icons = {
      success: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
        <path d="M20 6L9 17l-5-5"/>
      </svg>`,
      error: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
        <line x1="18" y1="6" x2="6" y2="18"/>
        <line x1="6" y1="6" x2="18" y2="18"/>
      </svg>`,
      warning: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
        <line x1="12" y1="8" x2="12" y2="12"/>
        <line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>`,
      info: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
        <line x1="12" y1="16" x2="12" y2="12"/>
        <line x1="12" y1="8" x2="12.01" y2="8"/>
      </svg>`,
      confirm: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
        <path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3"/>
        <line x1="12" y1="17" x2="12.01" y2="17"/>
      </svg>`
    }
    return icons[type] || icons.info
  }
}
