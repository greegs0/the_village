module ApplicationHelper
  # Convertit le markdown basique en HTML (bold, italic, listes)
  def simple_markdown(text)
    return "" if text.blank?

    # Échapper le HTML d'abord pour la sécurité
    escaped = ERB::Util.html_escape(text)

    # Convertir **texte** en <strong>texte</strong>
    escaped = escaped.gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')

    # Convertir *texte* en <em>texte</em>
    escaped = escaped.gsub(/\*(.+?)\*/, '<em>\1</em>')

    # Convertir les retours à la ligne en <br>
    escaped = escaped.gsub(/\n/, '<br>')

    # Convertir les listes à puces (- item)
    escaped = escaped.gsub(/^- (.+)/, '• \1')

    escaped.html_safe
  end
end
