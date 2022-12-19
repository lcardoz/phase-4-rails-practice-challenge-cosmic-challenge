class ScientistsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  # rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    render json: Scientist.all, status: :ok
  end

  def show
    scientist = find_scientist
    render json: scientist, status: :ok,
    serializer: ScientistPlanetSerializer 
  end

  def create
    scientist = Scientist.create!(scientist_params)
    render json: scientist, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages },
    status: :unprocessable_entity
  end

  def update
    scientist = find_scientist
    scientist.update!(scientist_params)
    render json: scientist, status: :accepted
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages },
    status: :unprocessable_entity
  end

  def destroy
    scientist = find_scientist
    scientist.destroy
    render json: {}, status: :no_content
  end

  private

  def find_scientist
    Scientist.find(params[:id])
  end

  def scientist_params
    params.permit(:name, :field_of_study, :avatar)
  end

  def render_not_found_response
    render json: { "error": 'Scientist not found' }, 
    status: :not_found
  end

  # def render_unprocessable_entity_response(invalid)
  #   render json: { errors: invalid.record.errors.messages }, 
  #   status: :unprocessable_entity
  # end

end
