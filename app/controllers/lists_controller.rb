class ListsController < ApplicationController
  before_action :authorize_user
  before_action :set_list, only: %i[update destroy]

  def create
    @board = Board.find(params[:board_id])
    @list = @board.lists.new(list_params)

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :pos, :closed)
  end

  def authorize_user
    board = Board.find(params[:board_id])
    return if current_user == board.user

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
