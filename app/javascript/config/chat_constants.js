// ============================================================
// CHAT CONSTANTS
// ============================================================
// Constantes pour le système de chat (évite les valeurs magiques)
// ============================================================

export const CHAT_CONSTANTS = {
  // Dimensions
  AVATAR_SIZE_SM: 28,
  AVATAR_SIZE_MD: 32,
  AVATAR_SIZE_LG: 40,

  // CSS Classes
  MESSAGE_CONTAINER: 'd-flex mb-3',
  MESSAGE_CONTAINER_USER: 'd-flex mb-3 justify-content-end',
  MESSAGE_BUBBLE_USER: 'chat-message-bubble user-message',
  MESSAGE_BUBBLE_ASSISTANT: 'chat-message-bubble assistant-message',
  MESSAGE_AVATAR: 'me-2',
  MESSAGE_CONTENT: 'flex-grow-1',
  MESSAGE_TIME: 'message-time',

  // Timestamps
  TIME_FORMAT_OPTIONS: { hour: '2-digit', minute: '2-digit' },
  TIME_LOCALE: 'fr-FR',

  // Messages
  WELCOME_MESSAGE: 'Bonjour ! Je suis l\'assistant de The Village. Comment puis-je vous aider aujourd\'hui ?',
  LOADING_MESSAGE: 'L\'assistant rédige sa réponse...',

  // Delays
  RESPONSE_DELAY_MS: 1000,
}
