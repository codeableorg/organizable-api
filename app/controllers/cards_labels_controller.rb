class CardsLabelsController < ApplicationController
  before_action :authorize_user
  before_action :set_card_label, only: %i[create destroy]

  def create
    @card.labels << @label unless @card.labels.exists?(@label.id)
    render json: @card.labels, status: :ok
  end

  # POST /cards/[card_id]/cards_labels?label_id=[434]   [id_card] <---> [id_label] check!
  # DELETE /cards/[card_id]/cards_labels?label_id=[434]    [id_card] <-X-> [id_label] check!

  def destroy
    @card.labels.delete(@label)
    render json: @card.labels, status: :ok
  end

  private

  def set_card_label
    @card = Card.find(params[:card_id])
    @label = Label.find(params[:label_id])
  end

  def authorize_user
    card = Card.find(params[:card_id])
    card_owner = card.list.board.user
    return if current_user == card_owner

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
