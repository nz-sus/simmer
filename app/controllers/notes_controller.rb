class NotesController < ApplicationController
  def show
    @noteable = params[:type].camelize.constantize.find(params[:id])
    @notes = @noteable.notes
    @single_note = @noteable.note
    #check if we are showing a single note through the model relationship
    is_single_note = @noteable.class.reflect_on_association(:note).macro == :has_one

    render partial: 'notes/modal', locals: { notes: @notes, noteable: @noteable, single_note: @single_note, is_single_note: is_single_note}
  end
  def create
    @noteable = params[:type].camelize.constantize.find(params[:id])
    is_single_note = @noteable.class.reflect_on_association(:note).macro == :has_one
    @note = if is_single_note
      @noteable.build_note(content: params[:content])
    else
      @noteable.notes.new(content: params[:content])    
    end
    @note.save
    render partial: 'notes/note', locals: { note: @note }
  end

end
