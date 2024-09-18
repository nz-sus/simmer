class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy export report ]

  def set_active
    session[:active_client_id] = params[:client_id]
    redirect_to client_path(session[:active_client_id])
  end

  def set_minimum_display_severity
    session[:minimum_display_severity] = params[:minimum_display_severity]
    redirect_to client_path(session[:active_client_id])
  end

  # GET /clients or /clients.json
  def index
    @clients = Client.all
  end
  
  # GET /clients/1 or /clients/1.json
  def show
    @minimum_display_severity = session[:minimum_display_severity] || 'UNKNOWN'
  end

  def export    
    render template: 'clients/show', layout: 'export'    
  end

  def report
    @minimum_display_severity = session[:minimum_display_severity] || 'UNKNOWN'    
    if params[:export] == 'html'    
      render template: 'clients/report', layout: 'export'    
    end
  end



  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_url(@client), notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_url(@client), notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.destroy!

    respond_to do |format|
      format.html { redirect_to clients_url, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:name)
    end
end
