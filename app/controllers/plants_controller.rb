class PlantsController < ApplicationController
  # assign @plant variable based on params[:id]
  before_action :find_plant, only: %i[show update destroy]

  # error handling for non-existent records and failed validations
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_response

  # GET /plants
  def index
    plants = Plant.all
    render json: plants
  end

  # GET /plants/:id
  def show
    render json: @plant
  end

  # POST /plants
  def create
    plant = Plant.create!(plant_params)
    render json: plant, status: :created
  end

  # PATCH /plants/:id
  def update
    @plant.update!(plant_params)
    render json: @plant, status: :accepted
  end

  # DELETE /plants/:id
  def destroy
    @plant.destroy

    head :no_content
    # render json: @plant, status: :ok
  end

  private

  # set instance variable for show/update/destroy
  def find_plant
    @plant = Plant.find(params[:id])
  end

  # permissible params to be used by create/update
  def plant_params
    params.permit(:id, :name, :image, :price, :is_in_stock)
  end

  # response when requested plant not in database
  def render_not_found_response
    render json: { error: 'Not found' }, status: :not_found
  end

  # response when plant failed validations to be created/updated
  def render_invalid_response(error_obj)
    render json: {
             errors: error_obj.record.errors.full_messages
           },
           status: :unprocessable_entity
  end
end
