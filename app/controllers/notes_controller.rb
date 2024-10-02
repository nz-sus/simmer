class NotesController < ApplicationController
  def show
    @note_class = class_for_note(params[:type]).find_by_id(params[:id])
    @note = @note_class.note

    render partial: 'notes/modal', locals: { note: @note, noteable: @note_class}
  end
  def create
    @note_class = class_for_note(params[:type]).find_by_id(params[:id])
    
    @note_class.update!(note: note_params[:content])
    
    render partial: 'notes/note', locals: { note: @note }
  end

  private

  def class_for_note(type_name)
    case type_name
    when 'GitleaksResult', 'gitleaks_result'
      GitleaksResult
    when 'MaskedSecret', 'masked_secret'
      MaskedSecret
    else
      raise "Invalid note type"
    end
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
