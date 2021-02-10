class ChecklistsController < ApplicationController
  before_action :authorize_user
  before_action :set_checklist, only: %i[update destroy]

  def create
    @card = Card.find(params[:card_id])
    @checklist = @card.checklists.new(checklist_params)

    if @checklist.save
      render json: @checklist, status: :created
    else
      render json: @checklist.errors, status: :unprocessable_entity
    end
  end

  def update
    if @checklist.update(checklist_params)
      render json: @checklist
    else
      render json: @checklist.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @checklist.destroy
  end

  private

  def set_checklist
    @checklist = Checklist.find(params[:id])
  end

  def checklist_params
    params.require(:checklist).permit(:name, :pos)
  end

  def authorize_user
    card = Card.find(params[:card_id])
    card_owner = card.list.board.user
    return if current_user == card_owner

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
