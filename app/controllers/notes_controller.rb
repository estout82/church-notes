class NotesController < ApplicationController
  before_action :require_login!
  before_action :require_editor!, except: [:search]
  before_action :set_note!, only: %i[show edit update destroy]
  before_action :set_policy
  before_action { @current_page = :notes }

  def index
    @notes = Note.where(account: current_account).order(created_at: :desc)
  end

  def show
    respond_to do |format|
      format.json { render json: @note.to_api_object.to_json, status: :ok }
    end
  end

  def edit
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to edit that note",
        status: :forbidden
      )

      return
    end

    @current_sub_page = :edit
  end

  def update
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to edit that note",
        status: :forbidden
      )

      return
    end

    field = params.fetch(:field, nil)
    editor_data = params[:note][:editor_data]

    if field
      @note[field] = note_params[field]
    elsif editor_data
      @note.editor_data = editor_data
    end

    if @note.save
      respond_to do |format|
        format.turbo_stream
        format.json { head :no_content }
      end
    else
      head :bad_request
    end
  end

  def new
    unless @policy.can_create?
      toast(
        "Sorry, you're not allowed to create notes",
        status: :forbidden
      )

      return
    end

    @note = Note.new
  end

  def create
    unless @policy.can_create?
      toast(
        "Sorry, you're not allowed to create notes",
        status: :forbidden
      )

      return
    end

    @note = Note.new title: "New Note"
    @note.account = current_account

    if @note.save
      redirect_to edit_note_path(@note)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    unless @policy.can_destroy?
      toast(
        "Sorry, you're not allowed to delete that note",
        status: :forbidden
      )

      return
    end

    @note = Note.find_by! alt_id: params[:alt_id]

    if @note.destroy
      flash[:success] = "Deleted note successfully"
      redirect_to notes_path
    else
      toast "Sorry, we weren't able to delete this note"
    end
  end

  def search
    query = params[:query]

    @notes = NoteDecider.new(account: current_account)
      .run
      .where("title ILIKE ?", "%#{query}%")

    respond_to do |format|
      format.html
      format.json do
        render json: @notes
      end
    end
  end

  private

  #
  # actions
  #

  def require_editor!
    unless current_user.permissions.for_account? current_account, :editor
      toast(
        "Sorry, you're not allowed to edit notes for this account",
        status: :forbidden
      )
    end
  end

  def set_note!
    @note = Note.find_by! alt_id: params[:alt_id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, we couldn't find that note",
      status: :not_found
    )
  end

  def set_policy
    @policy = NotePolicy.new current_user, current_account, @note
  end

  #
  # params
  #

  def note_params
    params
      .require(:note)
      .permit(:title, :sharing)
  end

  class MissingFieldError < StandardError; end
end
