import { Controller } from "@hotwired/stimulus"
import { CHAT_CONSTANTS } from "../config/chat_constants"

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
      this.addAssistantMessage(CHAT_CONSTANTS.API_PENDING_MESSAGE)
    }, CHAT_CONSTANTS.RESPONSE_DELAY_MS)
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
    messageDiv.className = CHAT_CONSTANTS.MESSAGE_CONTAINER_USER
    messageDiv.innerHTML = `
      <div style="max-width: 85%;">
        <div class="${CHAT_CONSTANTS.MESSAGE_BUBBLE_USER}">
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
    messageDiv.className = CHAT_CONSTANTS.MESSAGE_CONTAINER
    messageDiv.innerHTML = `
      <div class="${CHAT_CONSTANTS.MESSAGE_AVATAR}">
        <img src="${CHAT_CONSTANTS.ASSISTANT_AVATAR_PATH}" alt="Assistant" style="width: ${CHAT_CONSTANTS.AVATAR_SIZE_MD}px; height: ${CHAT_CONSTANTS.AVATAR_SIZE_MD}px;">
      </div>
      <div class="${CHAT_CONSTANTS.MESSAGE_CONTENT}">
        <div class="${CHAT_CONSTANTS.MESSAGE_BUBBLE_ASSISTANT}">
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
    return now.toLocaleTimeString(CHAT_CONSTANTS.TIME_LOCALE, CHAT_CONSTANTS.TIME_FORMAT_OPTIONS)
  }

  // Échapper le HTML pour éviter XSS
  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
