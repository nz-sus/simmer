class IncidentsController < ApplicationController
  before_action :set_incident, only: %i[ show edit update destroy ]

  # GET /incidents or /incidents.json
  def index
    @incidents = Incident.all
  end

  # GET /incidents/1 or /incidents/1.json
  def show
  end

  # GET /incidents/new
  def new
    # If we are passed gitleaks_result_ids, use a hidden field to pass them through to create
    @incident = Incident.new(incident_params.merge(opened_at: Time.current))
    if params[:gitleaks_result_ids]
      @incident.gitleaks_result_ids = params[:gitleaks_result_ids]
    end
  end

  # GET /incidents/1/edit
  def edit
  end

  # POST /incidents or /incidents.json
  def create
    @incident = Incident.new(incident_params.except(:initial_gitleaks_result_ids))
    if incident_params[:initial_gitleaks_result_ids]
      @incident.gitleaks_results = GitleaksResult.where(id:incident_params[:initial_gitleaks_result_ids].split(","))
    end

    respond_to do |format|
      if @incident.save
        format.html { redirect_to incident_url(@incident), notice: "Incident was successfully created." }
        format.json { render :show, status: :created, location: @incident }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incidents/1 or /incidents/1.json
  def update
    respond_to do |format|
      if @incident.update(incident_params)
        format.html { redirect_to incident_url(@incident), notice: "Incident was successfully updated." }
        format.json { render :show, status: :ok, location: @incident }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incidents/1 or /incidents/1.json
  def destroy
    @incident.destroy!

    respond_to do |format|
      format.html { redirect_to incidents_url, notice: "Incident was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident
      @incident = Incident.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def incident_params
      params.require(:incident).permit(:name, :opened_at, :closed_at, :client_id, :initial_gitleaks_result_ids)
    end
end
