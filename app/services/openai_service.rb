class OpenaiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def chat_completion(messages_history, family_context = nil)
    # Construire le contexte système avec les informations de la famille
    system_message = build_system_message(family_context)

    # Formater l'historique des messages pour OpenAI
    formatted_messages = [
      { role: "system", content: system_message }
    ]

    # Ajouter l'historique des messages
    messages_history.each do |msg|
      formatted_messages << {
        role: msg.from_assistant? ? "assistant" : "user",
        content: msg.content
      }
    end

    begin
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: formatted_messages,
          temperature: 0.7,
          max_tokens: 500
        }
      )

      response.dig("choices", 0, "message", "content")
    rescue => e
      Rails.logger.error "OpenAI API Error: #{e.message}"
      "Désolé, je rencontre un problème technique. Pourriez-vous réessayer ?"
    end
  end

  private

  def build_system_message(family_context)
    current_date = I18n.l(Date.today, format: :long)

    base_message = <<~TEXT
      Tu es l'assistant virtuel de The Village, une application d'organisation familiale.
      Date actuelle : #{current_date}

      Ton rôle est d'aider les utilisateurs à :
      - Organiser leur vie de famille
      - Gérer les tâches du foyer
      - Planifier les événements familiaux
      - Répondre aux questions sur l'utilisation de l'application
      - Fournir des informations fiables sur la santé, l'éducation et le développement des enfants

      SOURCES OFFICIELLES À CONNAÎTRE :
      Pour les questions sur la petite enfance (0-3 ans) :
      → https://www.1000-premiers-jours.fr/fr

      Pour les questions sur les vaccinations obligatoires :
      → https://www.ameli.fr/assure/sante/themes/vaccination/vaccins-obligatoires
      → https://vaccination-info-service.fr/Questions-frequentes/Questions-pratiques/Quand-dois-je-me-faire-vacciner/Comment-savoir-quels-vaccins-faire

      Pour les questions sur le calendrier scolaire :
      → https://www.education.gouv.fr/calendrier-scolaire-100148

      RÈGLES IMPORTANTES :
      1. Adopte un ton chaleureux, bienveillant et professionnel.
      2. UTILISE TOUJOURS le contexte de la famille dans tes réponses :
         - Mentionne les prénoms et âges des enfants quand c'est pertinent
         - Adapte tes conseils à l'âge spécifique de chaque enfant
         - Utilise le code postal pour donner des informations locales (ex: calendrier scolaire de zone)
         - Personnalise chaque réponse en fonction de la composition familiale
      3. Sois détaillé et informatif (4-6 phrases), pas juste concis.
      4. Si tu ne sais pas ou n'es pas sûr d'une information, DIS-LE CLAIREMENT. Ne jamais inventer une réponse.
      5. Pour les questions médicales/santé : toujours rediriger vers un professionnel de santé et mentionner les sources officielles ci-dessus.
      6. Pour les informations sensibles (santé, éducation), cite toujours la source officielle pertinente.
      7. Si l'utilisateur pose une question hors du contexte familial/organisation, ramène poliment la conversation vers ton domaine d'expertise.
    TEXT

    if family_context
      base_message += <<~TEXT


        Contexte de la famille :
        - Nom : #{family_context[:name]}
        - Membres : #{family_context[:members_info]}
        - Code postal : #{family_context[:zipcodes]}
        - Tâches actives : #{family_context[:tasks_count]}
        - Événements à venir : #{family_context[:events_count]}
      TEXT
    end

    base_message
  end
end
