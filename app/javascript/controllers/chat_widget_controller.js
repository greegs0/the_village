import { Controller } from "@hotwired/stimulus"
import { CHAT_CONSTANTS } from "config/chat_constants"

// Connects to data-controller="chat-widget"
export default class extends Controller {
  static targets = ["modal", "messages", "input", "form", "popup"]
  static values = {
    avatarUrl: String,
    iconUrl: String
  }

  connect() {
    // Récupérer l'ID du chat depuis localStorage (persistance entre pages)
    this.currentChatId = localStorage.getItem('widget_chat_id')
    this.isLoading = false

    // Si un chat existe, charger ses messages
    if (this.currentChatId) {
      this.loadChatMessages()
    }

    // Auto-focus sur l'input si la modal est ouverte
    if (this.hasModalTarget && this.modalTarget.style.display === 'block') {
      this.inputTarget.focus()
      this.scrollToBottom()
    }
  }

  // Headers communs pour les requêtes fetch
  get fetchHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      'Accept': 'application/json'
    }
  }

  // Réinitialiser le chat (localStorage + state)
  resetChat() {
    localStorage.removeItem('widget_chat_id')
    this.currentChatId = null
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
  async sendMessage(event) {
    event.preventDefault()

    const messageText = this.inputTarget.value.trim()
    if (messageText === '' || this.isLoading) return

    // Ajouter le message de l'utilisateur
    this.addUserMessage(messageText)

    // Vider l'input et désactiver pendant le chargement
    this.inputTarget.value = ''
    this.isLoading = true
    this.inputTarget.disabled = true

    try {
      // Si pas de chat actif, en créer un
      if (!this.currentChatId) {
        await this.createChat()
      }

      // Afficher un indicateur de chargement
      const loadingDiv = this.addLoadingIndicator()

      // Envoyer le message à l'API
      const response = await this.postMessage(messageText)

      // Retirer l'indicateur de chargement
      loadingDiv.remove()

      // Ajouter la réponse de l'assistant
      if (response.assistant_message) {
        this.addAssistantMessage(response.assistant_message.content)
      }
    } catch (error) {
      console.error('Erreur lors de l\'envoi du message:', error)
      this.addAssistantMessage('Désolé, une erreur est survenue. Veuillez réessayer.')
    } finally {
      this.isLoading = false
      this.inputTarget.disabled = false
      this.inputTarget.focus()
    }
  }

  // Créer un nouveau chat
  async createChat() {
    const response = await fetch('/chats', {
      method: 'POST',
      headers: this.fetchHeaders,
      body: JSON.stringify({ chat: { title: 'Nouvelle conversation' } })
    })

    if (!response.ok) {
      throw new Error('Erreur lors de la création du chat')
    }

    const data = await response.json()
    this.currentChatId = data.chat.id

    // Persister l'ID du chat dans localStorage
    localStorage.setItem('widget_chat_id', this.currentChatId)

    // Supprimer le message de bienvenue par défaut et ajouter le message personnalisé
    this.messagesTarget.innerHTML = ''
    if (data.welcome_message) {
      this.addAssistantMessage(data.welcome_message.content)
    }

    return data
  }

  // Envoyer un message à l'API
  async postMessage(messageText) {
    const response = await fetch(`/chats/${this.currentChatId}/messages`, {
      method: 'POST',
      headers: this.fetchHeaders,
      body: JSON.stringify({ message: { content: messageText } })
    })

    if (!response.ok) {
      throw new Error('Erreur lors de l\'envoi du message')
    }

    return await response.json()
  }

  // Charger les messages d'un chat existant
  async loadChatMessages() {
    try {
      const response = await fetch(`/chats/${this.currentChatId}`, {
        headers: { 'Accept': 'application/json' }
      })

      if (!response.ok) {
        this.resetChat()
        return
      }

      const data = await response.json()

      // Vider les messages par défaut et afficher l'historique
      this.messagesTarget.innerHTML = ''
      data.messages.forEach(message => {
        if (message.role === 'user') {
          this.addUserMessage(message.content)
        } else {
          this.addAssistantMessage(message.content)
        }
      })
    } catch (error) {
      console.error('Erreur lors du chargement des messages:', error)
      this.resetChat()
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

  // Ajouter un message assistant (avec formatage markdown)
  addAssistantMessage(text) {
    const messageDiv = this.createAssistantBubble(
      `<p class="mb-1">${this.simpleMarkdown(text)}</p>
       <small class="text-muted" style="font-size: 11px;">${this.getCurrentTime()}</small>`
    )
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  // Ajouter un indicateur de chargement avec spinner
  addLoadingIndicator() {
    const loadingDiv = document.createElement('div')
    loadingDiv.className = CHAT_CONSTANTS.MESSAGE_CONTAINER
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

  // Créer une bulle de message assistant (structure commune)
  createAssistantBubble(innerContent) {
    const messageDiv = document.createElement('div')
    messageDiv.className = CHAT_CONSTANTS.MESSAGE_CONTAINER
    messageDiv.innerHTML = `
      <div class="${CHAT_CONSTANTS.MESSAGE_AVATAR}">
        <img src="${this.avatarUrlValue}" alt="Assistant" style="width: ${CHAT_CONSTANTS.AVATAR_SIZE_MD}px; height: ${CHAT_CONSTANTS.AVATAR_SIZE_MD}px;">
      </div>
      <div class="${CHAT_CONSTANTS.MESSAGE_CONTENT}">
        <div class="${CHAT_CONSTANTS.MESSAGE_BUBBLE_ASSISTANT}">
          ${innerContent}
        </div>
      </div>
    `
    return messageDiv
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

  // Convertit le markdown basique en HTML (équivalent de simple_markdown en Ruby)
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
