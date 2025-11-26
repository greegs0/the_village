class ActionExecutorService
  def initialize(user, family)
    @user = user
    @family = family
  end

  # Exécute les actions suggérées par l'assistant
  def execute_actions(actions_data)
    results = {
      tasks_created: [],
      event_created: nil,
      errors: []
    }

    # Créer les tâches
    if actions_data["tasks"].present?
      actions_data["tasks"].each do |task_data|
        task_result = create_task(task_data)
        if task_result[:success]
          results[:tasks_created] << task_result[:task]
        else
          results[:errors] << task_result[:error]
        end
      end
    end

    # Créer l'événement
    if actions_data["event"].present?
      event_result = create_event(actions_data["event"])
      if event_result[:success]
        results[:event_created] = event_result[:event]
      else
        results[:errors] << event_result[:error]
      end
    end

    results
  end

  # Rééquilibre les tâches selon les suggestions de l'IA
  def rebalance_tasks(rebalancing_data)
    results = {
      tasks_reassigned: [],
      errors: []
    }

    return results unless rebalancing_data["reassignments"].present?

    rebalancing_data["reassignments"].each do |reassignment|
      task_name = reassignment["task_name"]
      new_assignee_name = reassignment["new_assignee"]

      # Trouver la tâche
      task = @family.tasks.where(status: false).find_by("name ILIKE ?", "%#{task_name}%")
      next unless task

      # Trouver le nouveau assigné
      new_assignee = @family.people.find_by("name ILIKE ?", "%#{new_assignee_name}%")
      next unless new_assignee

      # Réassigner la tâche
      if task.update(assignee: new_assignee)
        results[:tasks_reassigned] << {
          task: task,
          old_assignee: task.assignee_was&.name,
          new_assignee: new_assignee.name
        }
      else
        results[:errors] << "Impossible de réassigner '#{task_name}'"
      end
    end

    results
  end

  private

  def create_task(task_data)
    # Trouver l'assigné
    assignee = find_person_by_name(task_data["assignee"])

    # Si pas d'assigné trouvé, assigner au premier membre adulte (ou premier membre de la famille)
    unless assignee
      assignee = @family.people.order(:birthday).first # Le plus âgé en premier
      Rails.logger.warn "⚠️ Aucun assigné trouvé pour '#{task_data['name']}', assignation à #{assignee&.name}"

      unless assignee
        return { success: false, error: "Impossible de trouver un membre pour '#{task_data['name']}'" }
      end
    end

    # Calculer la date cible (ajuster si dans le passé)
    target_date = parse_task_date(task_data["target_date"])

    # Créer la tâche
    task = @family.tasks.new(
      name: task_data["name"],
      assignee: assignee,
      user: @user,
      target_date: target_date,
      status: false
    )

    if task.save
      { success: true, task: task }
    else
      { success: false, error: "Erreur lors de la création de '#{task_data['name']}': #{task.errors.full_messages.join(', ')}" }
    end
  end

  def create_event(event_data)
    # Mapper le type d'événement
    event_type = map_event_type(event_data["event_type"])

    # Calculer la date de l'événement
    start_date = parse_event_date(event_data, event_type)

    event = @family.family_events.new(
      title: event_data["title"],
      event_type: event_type,
      start_date: start_date,
      end_date: event_data["end_date"]&.to_date
    )

    if event.save
      { success: true, event: event }
    else
      { success: false, error: "Erreur lors de la création de l'événement '#{event_data['title']}': #{event.errors.full_messages.join(', ')}" }
    end
  end

  # Parse et ajuste la date de l'événement
  def parse_event_date(event_data, event_type)
    start_date = event_data["start_date"]&.to_date

    # Si pas de date, utiliser aujourd'hui
    return Date.today unless start_date

    # Si la date est dans le passé, ajuster selon le type d'événement
    if start_date < Date.today
      if event_type == 'anniversaire'
        # Pour les anniversaires : calculer la prochaine occurrence annuelle
        next_birthday = Date.new(Date.today.year, start_date.month, start_date.day)
        next_birthday = next_birthday.next_year if next_birthday < Date.today
        Rails.logger.info "🎂 Anniversaire ajusté de #{start_date} à #{next_birthday}"
        return next_birthday
      else
        # Pour les autres événements : ajuster à la même date de l'année courante/suivante
        adjusted_date = Date.new(Date.today.year, start_date.month, start_date.day)
        adjusted_date = adjusted_date.next_year if adjusted_date < Date.today
        Rails.logger.info "📅 Événement ajusté de #{start_date} à #{adjusted_date}"
        return adjusted_date
      end
    end

    start_date
  end

  # Parse et ajuste la date d'une tâche
  def parse_task_date(target_date_string)
    # Si pas de date fournie, par défaut 7 jours
    return 7.days.from_now.to_date if target_date_string.blank?

    target_date = target_date_string.to_date

    # Si la date est dans le passé, ajuster à la prochaine occurrence
    if target_date < Date.today
      # Calculer le même jour/mois mais année courante ou suivante
      adjusted_date = Date.new(Date.today.year, target_date.month, target_date.day)

      # Si déjà passé cette année, prendre l'année prochaine
      adjusted_date = adjusted_date.next_year if adjusted_date < Date.today

      Rails.logger.info "📅 Tâche ajustée de #{target_date} à #{adjusted_date}"
      return adjusted_date
    end

    target_date
  rescue ArgumentError => e
    # En cas d'erreur de parsing de date, utiliser la valeur par défaut
    Rails.logger.warn "⚠️ Erreur de parsing de date '#{target_date_string}': #{e.message}"
    7.days.from_now.to_date
  end

  def find_person_by_name(name)
    return nil if name.blank?

    # Recherche insensible à la casse et aux accents
    @family.people.find_by("name ILIKE ?", "%#{name}%")
  end

  def map_event_type(type_string)
    # Normaliser le type d'événement
    type_mapping = {
      'anniversaire' => 'anniversaire',
      'birthday' => 'anniversaire',
      'garde' => 'garde',
      'childcare' => 'garde',
      'medical' => 'medical',
      'médical' => 'medical',
      'scolaire' => 'scolaire',
      'school' => 'scolaire',
      'vacances' => 'vacances',
      'vacation' => 'vacances',
      'indisponibilite' => 'indisponibilite',
      'indisponibilité' => 'indisponibilite',
      'unavailability' => 'indisponibilite'
    }

    type_mapping[type_string&.downcase] || 'autre'
  end
end
