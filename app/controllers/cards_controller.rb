class CardsController < ApplicationController
  before_action :authorize_user
  before_action :set_card, only: %i[show update destroy]

  def show
    render json: @card
  end

  def create
    @list = List.find(params[:list_id])
    @card = @list.cards.new(card_params)

    if @card.save
      render json: @card, status: :created
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  def update
    if @card.update(card_params)
      render json: @card
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @card.destroy
  end

  def sort
    ids = params[:ids]

    cards = ids.map.with_index do |id, index|
      card = Card.find(id)
      card.pos = index
      card
    end

    Card.transaction do
      cards.each(&:save!)
    end

    render json: cards
  end

  private

  def set_card
    @card = @list.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:name, :desc, :pos, :closed, :list_id)
  end

  def authorize_user
    @list = List.find(params[:list_id])
    list_owner = @list.board.user
    return if current_user == list_owner

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
