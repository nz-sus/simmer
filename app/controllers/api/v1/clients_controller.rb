# app/controllers/api/v1/clients_controller.rb
module Api
  module V1
    class ClientsController < ApiController
      before_action :set_client, only: [:show, :update, :destroy]
      before_action :can_read?, only: [:index, :show]
      before_action :can_write?, only: [:create, :update, :destroy]

      def index
        @clients = Client.all
        render json: @clients
      end

      def show
        render json: @client
      end

      def create
        @client = Client.new(client_params)
        if @client.save
          render json: @client, status: :created
        else
          render json: @client.errors, status: :unprocessable_entity
        end
      end

      def update
        if @client.update(client_params)
          render json: @client
        else
          render json: @client.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @client.destroy
      end

      private

      def set_client
        @client = Client.find(params[:id])
      end

      def client_params
        params.require(:client).permit(:name, :description)
      end
    end
  end
end
