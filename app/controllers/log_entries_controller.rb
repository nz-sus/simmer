class LogEntriesController < ApplicationController
  before_action :set_log_entry, only: %i[ show edit update destroy ]

  # GET /log_entries or /log_entries.json
  def index
    @log_entries = LogEntry.page(params[:page]||1).per(params[:count]||50) 
  end

  # GET /log_entries/1 or /log_entries/1.json
  def show
  end

  # GET /log_entries/new
  def new
    @log_entry = LogEntry.new
  end

  # GET /log_entries/1/edit
  def edit
  end

  # POST /log_entries or /log_entries.json
  def create
    @log_entry = LogEntry.new(log_entry_params)

    @log_entry.source = "web"

    respond_to do |format|
      if @log_entry.save
        format.html { redirect_to log_entry_url(@log_entry), notice: "Log entry was successfully created." }
        format.json { render :show, status: :created, location: @log_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @log_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /log_entries/1 or /log_entries/1.json
  def update
    respond_to do |format|
      if @log_entry.update(log_entry_params)
        format.html { redirect_to log_entry_url(@log_entry), notice: "Log entry was successfully updated." }
        format.json { render :show, status: :ok, location: @log_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @log_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /log_entries/1 or /log_entries/1.json
  def destroy
    @log_entry.destroy!

    respond_to do |format|
      format.html { redirect_to log_entries_url, notice: "Log entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log_entry
      @log_entry = LogEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def log_entry_params
      params.require(:log_entry).permit(:title, :data_schema, :timestamp, :data_json, :data_set_id, :source)
    end
end
