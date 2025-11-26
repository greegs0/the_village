class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def families
  end

  def families_documents
    @family = current_user.family
    @folders = @family.folders.includes(:documents)
    @recent_documents = @family.documents.recent.includes(:user, :folder).limit(10)
    @favorite_documents = @family.documents.favorites.includes(:user, :folder)
    @selected_document = @family.documents.find_by(id: params[:document_id]) if params[:document_id]
  end
end
