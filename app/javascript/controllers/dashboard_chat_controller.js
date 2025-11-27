import { Controller } from "@hotwired/stimulus"
import { CHAT_CONSTANTS } from "config/chat_constants"

// Connects to data-controller="dashboard-chat"
export default class extends Controller {
  static targets = ["messages", "input", "form"]
  static values = {
    avatarUrl: String,
    iconUrl: String
  }

  connect() {
    this.isLoading = false
    this.scrollToBottom()
    this.inputTarget.focus()
  }

  // Headers communs pour les requêtes fetch
  get fetchHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      'Accept': 'application/json'
    }
  }

  // Envoyer un message
  async sendMessage(event) {
    event.preventDefault()

    const messageText = this.inputTarget.value.trim()
    if (messageText === '' || this.isLoading) return

    // Récupérer l'URL du formulaire
    const formAction = this.formTarget.action

    // Ajouter le message de l'utilisateur
    this.addUserMessage(messageText)

    // Vider l'input et désactiver pendant le chargement
    this.inputTarget.value = ''
    this.isLoading = true
    this.inputTarget.disabled = true

    // Afficher l'indicateur de chargement
    const loadingDiv = this.addLoadingIndicator()

    try {
      // Envoyer le message à l'API
      const response = await fetch(formAction, {
        method: 'POST',
        headers: this.fetchHeaders,
        body: JSON.stringify({ message: { content: messageText } })
      })

      if (!response.ok) {
        throw new Error('Erreur lors de l\'envoi du message')
      }

      const data = await response.json()

      // Retirer l'indicateur de chargement
      loadingDiv.remove()

      // Ajouter la réponse de l'assistant
      if (data.assistant_message) {
        this.addAssistantMessage(data.assistant_message.content)
      }
    } catch (error) {
      console.error('Erreur lors de l\'envoi du message:', error)
      loadingDiv.remove()
      this.addAssistantMessage('Désolé, une erreur est survenue. Veuillez réessayer.')
    } finally {
      this.isLoading = false
      this.inputTarget.disabled = false
      this.inputTarget.focus()
    }
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
      <div class="flex-grow-1" style="max-width: 70%;">
        <div class="rounded-3 p-2" style="background: rgba(102, 126, 234, 0.15); border: 1px solid rgba(102, 126, 234, 0.25); color: #374151;">
          <p class="mb-1" style="font-size: 13px; line-height: 1.4;">${this.escapeHtml(text)}</p>
          <small class="text-muted" style="font-size: 11px;">${this.getCurrentTime()}</small>
        </div>
      </div>
    `
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  // Ajouter un message assistant (avec formatage markdown)
  addAssistantMessage(text) {
    const messageDiv = document.createElement('div')
    messageDiv.className = 'd-flex mb-3'
    messageDiv.innerHTML = `
      <div class="me-2">
        <div class="d-flex align-items-center justify-content-center" style="width: 28px; height: 28px;">
          <img src="${this.avatarUrlValue}" alt="Assistant" style="width: 28px; height: 28px;">
        </div>
      </div>
      <div class="flex-grow-1" style="max-width: 70%;">
        <div class="rounded-3 p-2" style="background: linear-gradient(135deg, rgba(102, 126, 234, 0.08) 0%, rgba(118, 75, 162, 0.08) 100%); border: 1px solid rgba(102, 126, 234, 0.15);">
          <p class="mb-1" style="font-size: 13px; line-height: 1.4;">${this.simpleMarkdown(text)}</p>
          <small class="text-muted" style="font-size: 11px;">${this.getCurrentTime()}</small>
        </div>
      </div>
    `
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  // Ajouter un indicateur de chargement avec spinner
  addLoadingIndicator() {
    const loadingDiv = document.createElement('div')
    loadingDiv.className = 'd-flex mb-3'
    loadingDiv.innerHTML = `
      <div class="chat-widget-loader">
        <div class="loader-icon-wrapper">
          <img src="${this.iconUrlValue}" alt="Assistant" class="loader-icon">
          <div class="loader-spinner"></div>
        </div>
        <span class="loader-text">${CHAT_CONSTANTS.LOADING_MESSAGE}</span>
      </div>
    `
    this.messagesTarget.appendChild(loadingDiv)
    this.scrollToBottom()
    return loadingDiv
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

  // Convertit le markdown basique en HTML
  simpleMarkdown(text) {
    if (!text) return ''

    // Échapper le HTML d'abord pour la sécurité
    let escaped = this.escapeHtml(text)

    // Convertir **texte** en <strong>texte</strong>
    escaped = escaped.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')

    // Convertir *texte* en <em>texte</em>
    escaped = escaped.replace(/\*(.+?)\*/g, '<em>$1</em>')

    // Convertir les retours à la ligne en <br>
    escaped = escaped.replace(/\n/g, '<br>')

    // Convertir les listes à puces (- item) en • item
    escaped = escaped.replace(/^- (.+)/gm, '• $1')

    return escaped
  }
}
