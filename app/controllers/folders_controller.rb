class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :set_folder, only: [:show, :update, :destroy]

  def index
    @folders = @family.folders.includes(:documents)
  end

  def show
    @documents = @folder.documents.includes(:user).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.json do
        documents_data = @documents.map do |doc|
          {
            id: doc.id,
            name: doc.name,
            file_type: doc.file_type,
            file_size: doc.file_size,
            is_favorite: doc.is_favorite,
            uploader_name: doc.uploader_name,
            folder_name: @folder.name,
            time_ago: doc.time_ago_display,
            icon: doc.icon_display,
            download_url: doc.file.attached? ? download_document_path(doc) : nil,
            preview_url: doc.file.attached? ? url_for(doc.file) : nil
          }
        end
        render json: { folder: @folder, documents: documents_data }
      end
    end
  end

  def create
    @folder = @family.folders.build(folder_params)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to families_documents_path, notice: 'Dossier créé avec succès.' }
        format.json { render json: @folder, status: :created }
      else
        format.html { redirect_to families_documents_path, alert: @folder.errors.full_messages.join(', ') }
        format.json { render json: { errors: @folder.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to families_documents_path, notice: 'Dossier mis à jour.' }
        format.json { render json: @folder }
      else
        format.html { redirect_to families_documents_path, alert: @folder.errors.full_messages.join(', ') }
        format.json { render json: { errors: @folder.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to families_documents_path, notice: 'Dossier supprimé.' }
      format.json { head :no_content }
    end
  end

  private

  def set_family
    @family = current_user.family
  end

  def set_folder
    @folder = @family.folders.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:name, :icon)
  end
end
