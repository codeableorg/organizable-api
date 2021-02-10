class LabelsController < ApplicationController
  before_action :authorize_user
  before_action :set_label, only: %i[update destroy]

  def create
    @board = Board.find(params[:board_id])
    @label = @board.labels.new(label_params)

    if @label.save
      render json: @label, status: :created
    else
      render json: @label.errors, status: :unprocessable_entity
    end
  end

  def update
    if @label.update(label_params)
      render json: @label
    else
      render json: @label.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @label.destroy
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name, :color)
  end

  def authorize_user
    board = Board.find(params[:board_id])
    return if current_user == board.user

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
