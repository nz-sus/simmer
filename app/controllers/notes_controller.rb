class NotesController < ApplicationController
  def show
    @noteable = class_for_note(params[:type]).find_by_id(params[:id])
    @notes = @noteable.notes
    @single_note = @noteable.note
    #check if we are showing a single note through the model relationship
    is_single_note = @noteable.class.reflect_on_association(:note).macro == :has_one

    render partial: 'notes/modal', locals: { notes: @notes, noteable: @noteable, single_note: @single_note, is_single_note: is_single_note}
  end
  def create
    @noteable = class_for_note(params[:type]).find_by_id(params[:id])
    is_single_note = @noteable.class.reflect_on_association(:note).macro == :has_one
    @note = if is_single_note
      @noteable.build_note(content: params[:content])
    else
      @noteable.notes.new(content: params[:content])    
    end
    @note.save
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
end
