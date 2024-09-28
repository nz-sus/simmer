class Api::Internal::BulkUploadController < ApplicationController
  # This action requires read permission
  def index
    if service_token.write_only?
      render json: { error: 'Unauthorized: Token is write-only' }, status: :forbidden
    else
      # Perform the read operation
      render json: { data: 'This is protected data!' }
    end
  end

  # This action requires write permission
  def create
    if service_token.read_only?
      render json: { error: 'Unauthorized: Token is read-only' }, status: :forbidden
    else
      # Perform the write operation
      render json: { success: 'Data has been created' }, status: :created
    end
  end

  # This action requires write permission
  def update
    if service_token.read_only?
      render json: { error: 'Unauthorized: Token is read-only' }, status: :forbidden
    else
      # Perform the update operation
      render json: { success: 'Data has been updated' }
    end
  end
end
