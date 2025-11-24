module EventsHelper
  def generate_fake_participants(count)
    first_names = ['Marie', 'Pierre', 'Sophie', 'Lucas', 'Emma', 'Thomas', 'Julie', 'Nicolas', 'Camille', 'Alexandre', 'Léa', 'Julien', 'Sarah', 'Antoine', 'Claire', 'Maxime', 'Laura', 'Baptiste', 'Chloé', 'Mathieu']
    last_names = ['Martin', 'Bernard', 'Dubois', 'Thomas', 'Robert', 'Richard', 'Petit', 'Durand', 'Leroy', 'Moreau', 'Simon', 'Laurent', 'Lefebvre', 'Michel', 'Garcia', 'David', 'Bertrand', 'Roux', 'Vincent', 'Fournier']

    return [] if count.nil? || count <= 0

    participants = []
    count.times do |i|
      first_name = first_names[i % first_names.length]
      last_name = last_names[i % last_names.length]
      participants << "#{first_name} #{last_name}"
    end

    participants
  end
end
