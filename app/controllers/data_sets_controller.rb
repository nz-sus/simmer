class DataSetsController < ApplicationController
  before_action :set_data_set, only: %i[ show edit update destroy import_json import_form ]

  # GET /data_sets or /data_sets.json
  def index
    @data_sets = active_client ? active_client.data_sets : DataSet.all 
  end

  # GET /data_sets/1 or /data_sets/1.json
  def show
    #TODO pull from static source
    @gitleaks_rule_ids = GitleaksResult.all.distinct.pluck(:rule_id)
  end

  # GET /data_sets/new
  def new
    @data_set = DataSet.new
  end

  # GET /data_sets/1/edit
  def edit
  end

  # POST /data_sets or /data_sets.json
  def create
    @data_set = DataSet.new(data_set_params)

    respond_to do |format|
      if @data_set.save
        format.html { redirect_to data_set_url(@data_set), notice: "Data set was successfully created." }
        format.json { render :show, status: :created, location: @data_set }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_sets/1 or /data_sets/1.json
  def update
    respond_to do |format|
      if @data_set.update(data_set_params)
        format.html { redirect_to data_set_url(@data_set), notice: "Data set was successfully updated." }
        format.json { render :show, status: :ok, location: @data_set }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sets/1 or /data_sets/1.json
  def destroy
    @data_set.destroy!

    respond_to do |format|
      format.html { redirect_to data_sets_url, notice: "Data set was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import_form
    # Add log entry to data set based on input data
    success = true
    log_entry_params = params.permit(:title, :data_schema)
    logger.info "Log entry params: #{log_entry_params}"
    if success
      flash[:success] = 'Log entry imported successfully!'
    else
      flash[:error] = 'Error importing entry'
    end

    redirect_to @data_set
  end
  
  def import_json
    # Ensure there's a file in the params
    if params[:file].present?
      # Grab the filename for source
      source_filename = params[:file].original_filename
      # Read the file
      file = params[:file].read
      schema_name = params[:schema_name]
      # Parse the JSON
      data = JSON.parse(file)
      
      # TODO parse timestamp from log/event entries. 
      entry_timestamp = Time.current

      # Assuming data is an array of objects
      data.each do |entry|
        # Create a new LogEntry for each object
        log_entry = LogEntry.create!(
          title: entry['Message'],
          data_schema: schema_name,
          source: source_filename,
          timestamp: entry_timestamp,
          #save the entry as a json string
          data_json: entry.to_json,
          data_set: @data_set
        )
      end

      flash[:success] = 'Log entries imported successfully!'
    else
      flash[:error] = 'Please provide a file.'
    end

    redirect_to @data_set
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_set
      @data_set = DataSet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def data_set_params
      params.require(:data_set).permit(:name, :time_range_start, :time_range_end, :client_id, :description, :schema_name, :source_url )
    end
end
