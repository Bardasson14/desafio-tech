# frozen_string_literal: true

class CollectionsController < ApplicationController
  before_action :fetch_instance, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[show index]

  def index
    selected_params = params.slice(*resource_class.filterable_columns)
    resources = resource_class.query_by_filters(selected_params)

    if params[:page].present? && params[:per_page].present?
      resources = resources.paginate(page: params[:page], per_page: params[:per_page])
    end

    render json: resources, each_serializer: resource_serializer
  end

  def show
    render json: @resource, serializer: resource_serializer
  end

  def create
    resource = resource_class.create allowed_params

    if resource.save
      render json: resource, serializer: resource_serializer
    else
      render json: {
        message: resource.errors.full_messages.uniq.join(', ')
      }, status: :internal_server_error
    end
  end

  def update
    if @resource.update allowed_params
      render json: @resource, serializer: resource_serializer
    else
      render json: {
        message: @resource.errors.full_messages.uniq.join(', ')
      }, status: :internal_server_error
    end
  end

  def destroy
    if @resource.destroy
      render json: { message: 'Exclusão bem-sucedida' }, status: :ok
    else
      render json: { message: 'Erro ao confirmar exclusão' }, status: :internal_server_error
    end
  end

  private

  def resource_class
    controller_name.classify.constantize
  end

  def resource_serializer
    "#{resource_class}Serializer".constantize
  end

  def fetch_instance
    @resource = resource_class.find params[:id]
  end

  def allowed_params
    params.require(controller_name.classify.underscore.to_sym).permit! # allow all params, by default
  end
end
