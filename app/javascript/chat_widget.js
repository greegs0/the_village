// ============================================================
// CHAT WIDGET FUNCTIONALITY
// ============================================================
// Gère l'ouverture/fermeture du widget de chat flottant
// ============================================================

document.addEventListener('DOMContentLoaded', function() {
  const chatButton = document.getElementById('chatWidgetButton');
  const chatModal = document.getElementById('chatWidgetModal');
  const closeButton = document.getElementById('closeChatWidget');
  const chatMessages = document.getElementById('chatWidgetMessages');
  const chatForm = document.getElementById('chatWidgetForm');
  const chatInput = document.getElementById('chatWidgetInput');

  // Ouvrir la modal
  if (chatButton) {
    chatButton.addEventListener('click', function() {
      if (chatModal.style.display === 'none' || chatModal.style.display === '') {
        chatModal.style.display = 'block';
        chatInput.focus();
        scrollToBottom();
      } else {
        chatModal.style.display = 'none';
      }
    });
  }

  // Fermer la modal
  if (closeButton) {
    closeButton.addEventListener('click', function() {
      chatModal.style.display = 'none';
    });
  }

  // Fermer la modal en cliquant en dehors
  document.addEventListener('click', function(event) {
    if (chatModal && chatButton) {
      const isClickInsideModal = chatModal.contains(event.target);
      const isClickOnButton = chatButton.contains(event.target);

      if (!isClickInsideModal && !isClickOnButton && chatModal.style.display === 'block') {
        chatModal.style.display = 'none';
      }
    }
  });

  // Envoyer un message
  if (chatForm) {
    chatForm.addEventListener('submit', function(e) {
      e.preventDefault();

      const messageText = chatInput.value.trim();
      if (messageText === '') return;

      // Ajouter le message de l'utilisateur
      addUserMessage(messageText);

      // Vider l'input
      chatInput.value = '';

      // TODO: Envoyer à l'API et recevoir la réponse
      // Pour l'instant, on simule une réponse
      setTimeout(function() {
        addAssistantMessage('Merci pour votre message ! L\'intégration de l\'API est en cours. Pour accéder à toutes les fonctionnalités, rendez-vous sur la page principale du chat.');
      }, 1000);
    });
  }

  // Raccourci Enter pour envoyer
  if (chatInput) {
    chatInput.addEventListener('keydown', function(e) {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        if (chatInput.value.trim() !== '') {
          chatForm.dispatchEvent(new Event('submit'));
        }
      }
    });
  }

  // Fonctions utilitaires
  function addUserMessage(text) {
    const messageDiv = document.createElement('div');
    messageDiv.className = 'd-flex mb-3 justify-content-end';
    messageDiv.innerHTML = `
      <div style="max-width: 85%;">
        <div class="chat-message-bubble user-message">
          <p class="mb-1">${escapeHtml(text)}</p>
          <small style="font-size: 11px;">${getCurrentTime()}</small>
        </div>
      </div>
    `;
    chatMessages.appendChild(messageDiv);
    scrollToBottom();
  }

  function addAssistantMessage(text) {
    const messageDiv = document.createElement('div');
    messageDiv.className = 'd-flex mb-3';
    messageDiv.innerHTML = `
      <div class="me-2">
        <img src="/assets/village-assistant-avatar.svg" alt="Assistant" style="width: 32px; height: 32px;">
      </div>
      <div class="flex-grow-1">
        <div class="chat-message-bubble assistant-message">
          <p class="mb-1">${escapeHtml(text)}</p>
          <small class="text-muted" style="font-size: 11px;">${getCurrentTime()}</small>
        </div>
      </div>
    `;
    chatMessages.appendChild(messageDiv);
    scrollToBottom();
  }

  function scrollToBottom() {
    if (chatMessages) {
      chatMessages.scrollTop = chatMessages.scrollHeight;
    }
  }

  function getCurrentTime() {
    const now = new Date();
    return now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
});
