class SearchesController < ApplicationController
  def global
    query = params[:query].to_s.strip

    if query.blank?
      render json: { results: [] }
      return
    end

    family = current_user.family
    results = []

    # Search in tasks
    tasks = family.tasks
                  .where('LOWER(name) LIKE ? OR LOWER(description) LIKE ?', "%#{query.downcase}%", "%#{query.downcase}%")
                  .limit(5)

    tasks.each do |task|
      results << {
        type: 'task',
        title: task.name,
        subtitle: task.description&.truncate(50) || "Échéance: #{I18n.l(task.target_date, format: :short)}",
        url: family_task_path(family, task),
        icon: 'check-square',
        status: task.status ? 'Terminée' : 'En cours'
      }
    end

    # Search in events
    events = family.family_events
                   .where('LOWER(title) LIKE ? OR LOWER(description) LIKE ?', "%#{query.downcase}%", "%#{query.downcase}%")
                   .limit(5)

    events.each do |event|
      results << {
        type: 'event',
        title: event.title,
        subtitle: "#{event.type_name} - #{I18n.l(event.start_date, format: :short)}",
        url: family_family_events_path(family),
        icon: 'calendar-alt',
        color: event.event_type_color
      }
    end

    # Search in documents
    documents = family.documents
                      .where('LOWER(name) LIKE ?', "%#{query.downcase}%")
                      .limit(5)

    documents.each do |doc|
      results << {
        type: 'document',
        title: doc.name,
        subtitle: "#{doc.file_type&.upcase} - #{number_to_human_size(doc.file_size || 0)}",
        url: document_path(doc),
        icon: 'file-alt'
      }
    end

    # Search in family members
    people = family.people
                   .where('LOWER(name) LIKE ?', "%#{query.downcase}%")
                   .limit(5)

    people.each do |person|
      results << {
        type: 'member',
        title: person.name,
        subtitle: person.birthday ? "#{person.age} ans" : "Membre de la famille",
        url: edit_person_path(person),
        icon: 'user'
      }
    end

    render json: { results: results }
  end
end
