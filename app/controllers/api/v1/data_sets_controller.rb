# app/controllers/api/v1/data_sets_controller.rb
module Api
  module V1
    class DataSetsController < ApplicationController
      before_action :set_client
      before_action :set_data_set, only: [:show, :update, :destroy]

      def index
        @data_sets = @client.data_sets
        render json: @data_sets
      end

      def show
        render json: @data_set
      end

      def create
        @data_set = @client.data_sets.find_or_create_by(data_set_params)
        if @data_set.save
          create_gitleaks_entries(@data_set, params[:gitleaks_json]) if params[:gitleaks_json]
          render json: @data_set, status: :created
        else
          render json: @data_set.errors, status: :unprocessable_entity
        end
      end

      def update
        if @data_set.update(data_set_params)
          create_gitleaks_entries(@data_set, params[:gitleaks_json]) if params[:gitleaks_json]
          render json: @data_set
        else
          render json: @data_set.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @data_set.destroy
      end

      def bulk_import
      end

      private

      def set_client
        @client = Client.find(session[:active_client_id])
      end

      def set_data_set
        @data_set = @client.data_sets.find(params[:id])
      end

      def data_set_params
        params.require(:data_set).permit(:name, :description)
      end

      def create_gitleaks_entries(data_set, gitleaks_json_file)
        gitleaks_json = File.read(gitleaks_json_file)
        entries = JSON.parse(gitleaks_json)
        schema_name = 'gitleaks'
        source_filename = File.basename(gitleaks_json_file)
        entry_timestamp = Time.now

        entries.each do |entry|
          # add log entry to data set, gitleaks entry is created automatically
          # Only create the log entry if this data_set and data_json combo doesn't already exist
          if LogEntry.exists?(data_set: data_set, data_json: entry.to_json)
            logger.info "Skipping duplicate entry"
            next
          end
          LogEntry.create!(
          title: entry['Message'],
          data_schema: schema_name,
          source: source_filename,
          timestamp: entry_timestamp,
          #save the entry as a json string
          data_json: entry.to_json,
          data_set: data_set
          )
          
        end
      end
    end
  end
end
