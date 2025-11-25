import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-widget"
export default class extends Controller {
  static targets = ["modal", "messages", "input", "form"]

  connect() {
    // Auto-focus sur l'input si la modal est ouverte
    if (this.hasModalTarget && this.modalTarget.style.display === 'block') {
      this.inputTarget.focus()
      this.scrollToBottom()
    }
  }

  // Ouvrir/fermer la modal
  toggle(event) {
    event.preventDefault()

    if (this.modalTarget.style.display === 'none' || this.modalTarget.style.display === '') {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.modalTarget.style.display = 'block'
    this.inputTarget.focus()
    this.scrollToBottom()
  }

  close() {
    this.modalTarget.style.display = 'none'
  }

  // Fermer au clic extérieur
  closeOnOutsideClick(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }

  // Envoyer un message
  sendMessage(event) {
    event.preventDefault()

    const messageText = this.inputTarget.value.trim()
    if (messageText === '') return

    // Ajouter le message de l'utilisateur
    this.addUserMessage(messageText)

    // Vider l'input
    this.inputTarget.value = ''

    // TODO: Envoyer à l'API et recevoir la réponse
    // Pour l'instant, on simule une réponse
    setTimeout(() => {
      this.addAssistantMessage('Merci pour votre message ! L\'intégration de l\'API est en cours. Pour accéder à toutes les fonctionnalités, rendez-vous sur la page principale du chat.')
    }, 1000)
  }

  // Raccourci Enter
  handleKeydown(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault()
      if (this.inputTarget.value.trim() !== '') {
        this.sendMessage(event)
      }
    }
  }

  // Ajouter un message utilisateur
  addUserMessage(text) {
    const messageDiv = document.createElement('div')
    messageDiv.className = 'd-flex mb-3 justify-content-end'
    messageDiv.innerHTML = `
      <div style="max-width: 85%;">
        <div class="chat-message-bubble user-message">
          <p class="mb-1">${this.escapeHtml(text)}</p>
          <small style="font-size: 11px;">${this.getCurrentTime()}</small>
        </div>
      </div>
    `
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  // Ajouter un message assistant
  addAssistantMessage(text) {
    const messageDiv = document.createElement('div')
    messageDiv.className = 'd-flex mb-3'
    messageDiv.innerHTML = `
      <div class="me-2">
        <img src="/assets/village-assistant-avatar.svg" alt="Assistant" style="width: 32px; height: 32px;">
      </div>
      <div class="flex-grow-1">
        <div class="chat-message-bubble assistant-message">
          <p class="mb-1">${this.escapeHtml(text)}</p>
          <small class="text-muted" style="font-size: 11px;">${this.getCurrentTime()}</small>
        </div>
      </div>
    `
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  // Scroll vers le bas
  scrollToBottom() {
    if (this.hasMessagesTarget) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }

  // Obtenir l'heure actuelle
  getCurrentTime() {
    const now = new Date()
    return now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })
  }

  // Échapper le HTML pour éviter XSS
  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
