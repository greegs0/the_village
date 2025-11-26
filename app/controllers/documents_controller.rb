class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :set_document, only: [:show, :update, :destroy, :toggle_favorite, :download]

  def index
    @documents = @family.documents.includes(:user, :folder).order(created_at: :desc)
    @recent_documents = @documents.limit(10)
    @favorite_documents = @family.documents.favorites.includes(:user, :folder)
  end

  def show
    respond_to do |format|
      format.html do
        redirect_to families_documents_path(document_id: @document.id)
      end
      format.json { render json: @document }
    end
  end

  def create
    @document = @family.documents.build(document_params)
    @document.user = current_user

    if params[:document][:file].present?
      @document.file.attach(params[:document][:file])
      @document.file_type = extract_file_type(params[:document][:file])
      @document.file_size = params[:document][:file].size
    end

    respond_to do |format|
      if @document.save
        format.html { redirect_to families_documents_path, notice: 'Document téléversé avec succès.' }
        format.json { render json: @document, status: :created }
      else
        format.html { redirect_to families_documents_path, alert: @document.errors.full_messages.join(', ') }
        format.json { render json: { errors: @document.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to families_documents_path, notice: 'Document mis à jour.' }
        format.json { render json: @document }
      else
        format.html { redirect_to families_documents_path, alert: @document.errors.full_messages.join(', ') }
        format.json { render json: { errors: @document.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.file.purge if @document.file.attached?
    @document.destroy
    respond_to do |format|
      format.html { redirect_to families_documents_path, notice: 'Document supprimé.' }
      format.json { head :no_content }
    end
  end

  def toggle_favorite
    @document.toggle_favorite!
    respond_to do |format|
      format.html { redirect_back fallback_location: families_documents_path }
      format.json { render json: { is_favorite: @document.is_favorite } }
    end
  end

  def download
    if @document.file.attached?
      redirect_to rails_blob_path(@document.file, disposition: 'attachment')
    else
      redirect_to families_documents_path, alert: 'Fichier non disponible.'
    end
  end

  private

  def set_family
    @family = current_user.family
  end

  def set_document
    @document = @family.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :folder_id, :is_favorite)
  end

  def extract_file_type(file)
    File.extname(file.original_filename).delete('.').downcase
  end
end
