class BoardsController < ApplicationController
  before_action :authorize_user, except: %i[index create]
  before_action :set_board, only: %i[show update destroy]
  COLORS = %w[green yellow orange red purple blue].freeze

  def index
    @boards = current_user.boards
    render json: @boards, each_serializer: AllBoardsSerializer
  end

  def show
    render json: @board, serializer: SingleBoardSerializer
  end

  def create
    @board = current_user.boards.new(board_params)
    if @board.save
      COLORS.each { |color| @board.labels.create(name: '', color: color) }
      render json: @board, status: :created, serializer: SingleBoardSerializer
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  def update
    if @board.update(board_params)
      render json: @board, serializer: SingleBoardSerializer
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, :closed, :desc, :color, :starred)
  end

  def authorize_user
    board = Board.find(params[:id])
    return if current_user == board.user

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
