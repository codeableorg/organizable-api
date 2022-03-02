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

  def sort
    ids = params[:ids]

    lists = ids.map.with_index do |id, index|
      list = List.find(id)
      list.pos = index
      list
    end

    List.transaction do
      lists.each(&:save!)
    end

    render json: lists
  end

  private

  def set_list
    @list = @board.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :pos)
  end

  def authorize_user
    @board = Board.find(params[:board_id])
    return if current_user == @board.user

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
