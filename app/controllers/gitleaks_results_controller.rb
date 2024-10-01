class GitleaksResultsController < ApplicationController  
  before_action :set_gitleaks_result, only: %i[ show edit update destroy add_tag remove_tag]


  # GET /gitleaks_results or /gitleaks_results.json
  
  def index
    # Generate available filters for [severity rule_id commit file]
    @available_filters = {}
    @active_filters = session[:filters] || {}
    @filter_value_map = GitleaksResult.filter_value_map

    active_client = fetch_active_client
    %w[severity rule_id commit file].each do |filter|
      glr = active_client ? active_client.gitleaks_results : GitleaksResult.all
      @available_filters[filter] = glr.distinct.pluck(filter).sort
    end

    # Add data_sets to available filters
    available_data_sets = active_client ? active_client.data_sets : DataSet.all
    @available_filters['data_set'] = available_data_sets.pluck(:id, :name)

    gitleaks_results_with_includes = GitleaksResult.includes([ :data_set, :log_entry, :notes, :tags, :masked_secret, :client])
    # if there is an active_client, only show results for that client
    if active_client
      gitleaks_results_with_includes = gitleaks_results_with_includes.where(data_set_id: active_client.data_sets.pluck(:id))
    end

    if params[:q].present?
      flash[:notice] = "Search results current ignore filters. Please be patient."
      @gitleaks_results = GitleaksResult.search(
        q: params[:q],
        q_type: params[:q_type],
        filters: @active_filters,
        sort: { sort_column => sort_direction }
      )
      # We need an activerecord search object to properly paginate. If there are more than 100 results, don't use this method. 
      
      if @gitleaks_results.count < 100
        #collect the ids of the results
        ids = @gitleaks_results.pluck(:id)
        #get the results in the order of the ids
        @gitleaks_results = gitleaks_results_with_includes.where(id: ids).order(sort_column + " " + sort_direction)#.page params[:page]
      else
        # add error notice and retrun all results
        flash.now[:notice] = "Search returned too many results. Showing all results instead."
        @gitleaks_results = gitleaks_results_with_includes.all
      end
    else
      @gitleaks_results = gitleaks_results_with_includes.all
      
      @active_filters.each do |key, values|
        # values may be an array of [id, name] or only ids. Grab only the ids
        query_values = values.map { |v| v.is_a?(Array) ? v[0] : v }
        @gitleaks_results = @gitleaks_results.where(key => query_values)
      end
          
      if params[:sort].present?
        @gitleaks_results = @gitleaks_results.order(sort_column + " " + sort_direction)
      end
    end
    @target_action = { controller: controller_name, action: :index }
    @gitleaks_results = @gitleaks_results.page params[:page]
  end

  # GET /gitleaks_results/1 or /gitleaks_results/1.json
  def show
  end

  # GET /gitleaks_results/new
  def new
    @gitleaks_result = GitleaksResult.new
  end

  # GET /gitleaks_results/1/edit
  def edit
  end

  # POST /gitleaks_results or /gitleaks_results.json
  def create
    @gitleaks_result = GitleaksResult.new(gitleaks_result_params)

    respond_to do |format|
      if @gitleaks_result.save
        format.html { redirect_to gitleaks_result_url(@gitleaks_result), notice: "Gitleaks result was successfully created." }
        format.json { render :show, status: :created, location: @gitleaks_result }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gitleaks_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gitleaks_results/1 or /gitleaks_results/1.json
  def update
    if params[:remove_tag]
      @gitleaks_result.tag_list.remove(params[:remove_tag])
      @gitleaks_result.save
    elsif params[:add_tag]
      @gitleaks_result.tag_list.add(params[:add_tag])
      @gitleaks_result.save
    else
      @gitleaks_result.update(gitleaks_result_params.except(:tag_list)) do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@gitleaks_result, :tag_list),
            partial: "gitleaks_results/tag_list",
            locals: { gitleaks_result: @gitleaks_result }
          )
        end
        format.html { redirect_to gitleaks_results_path }
      
      end  
      return
    end
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to gitleaks_results_path }
      format.json { head :no_content}
    end
    
  end

  # DELETE /gitleaks_results/1 or /gitleaks_results/1.json
  def destroy
    @gitleaks_result.destroy!

    respond_to do |format|
      format.html { redirect_to gitleaks_results_url, notice: "Gitleaks result was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Tags
  def add_tag    
    @gitleaks_result.tag_list.add(params[:add_tag])
    @gitleaks_result.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to gitleaks_results_path }
    end
  end

  def remove_tag    
    @gitleaks_result.tag_list.remove(params[:remove_tag])
    @gitleaks_result.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to gitleaks_results_path }
    end
  end


  def update_filters_g
    # A get wrapper for update_filters
    update_filters
  end

  def update_filters
    session[:filters] ||= {}

    begin
      if params[:add]
        to_add = JSON.parse(params[:add])
        to_add.each do |key, value|          
            session[:filters][key] ||= []
            session[:filters][key] << value unless session[:filters][key].include?(value)
        end
      elsif params[:remove]
        to_remove = JSON.parse(params[:remove])
        to_remove.each do |key, value|
          session[:filters][key].delete(value)
          session[:filters].delete(key) if session[:filters][key].empty?        
        end
      end
    rescue JSON::ParserError => e
    end
    @active_filters = session[:filters]

    @target_action = { controller: controller_name, action: :index }
    
    @gitleaks_results = GitleaksResult.includes([:data_set, :log_entry, :notes, :tags])
    active_client = fetch_active_client
    if active_client
      @gitleaks_results = @gitleaks_results.where(data_set_id: active_client.data_sets.pluck(:id))
    end

    @active_filters.each do |key, values|                    
      @gitleaks_results = @gitleaks_results.where(key => values)
    end
    @filter_value_map = GitleaksResult.filter_value_map
    @gitleaks_results = @gitleaks_results.page params[:page]
    html = render_to_string partial: "gitleaks_results/table", locals: { gitleaks_results: @gitleaks_results }

    filters_html = render_to_string(partial: "gitleaks_results/active_filters", locals: { active_filters: @active_filters, filter_value_map: @filter_value_map})

    
    cable_car = CableReady::CableCar.new
    cable_car.console_log(message: "Filters updated")
    # Add more operations as needed
    cable_car.inner_html(
      selector: '#gitleaks_results_table', 
      html: html
    )
    cable_car.inner_html(
      selector: "#active_filters",
      html: filters_html
    )
    # Broadcast the operations
    render json: cable_car, content_type: "text/vnd.cable-ready.json"
  end

  # Bulk Update Methods
  def assign_severities
    # Update the severities of the selected results
    raise "Severity mismatch" unless GitleaksResultService.severity_list.include?(params[:severity])

    if GitleaksResult.where(id: params[:gitleaks_result_ids].split(",")).update_all(severity: params[:severity])
      cable_car = CableReady::CableCar.new
      cable_car.console_log(message: "severities updated")
      # Initially reload the page
      cable_car.reload
      # TODO update the icons of changed values
      render json: cable_car, content_type: "text/vnd.cable-ready.json"
    else 
      render json: { error: "Failed to update severities" }, status: :unprocessable_entity
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gitleaks_result
      @gitleaks_result = GitleaksResult.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gitleaks_result_params
      params.require(:gitleaks_result).permit(:description, :start_line, :end_line, :start_column, 
        :end_column, :match, :secret, :file, :symlink_file, :commit, :entropy, :author, :email, 
        :severity, :date, :message, :gltags, :rule_id, :fingerprint, :log_entry_id, :tag_list)
    end
    def search_filters_params
      params.require(:filters).permit(:severity, :tags, :rule_id, :commit, :file, :data_set_id)
    end
    def sort_column
      # Ensure the sorting column is one of the allowed columns
      GitleaksResult.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
