class CheckItemsController < ApplicationController
  before_action :authorize_user
  before_action :set_check_item, only: %i[update destroy]

  def create
    @checklist = Checklist.find(params[:checklist_id])
    @check_item = @checklist.check_items.new(check_item_params)

    if @check_item.save
      render json: @check_item, status: :created
    else
      render json: @check_item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @check_item.update(check_item_params)
      render json: @check_item
    else
      render json: @check_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @check_item.destroy
  end

  private

  def set_check_item
    @check_item = CheckItem.find(params[:id])
  end

  def check_item_params
    params.require(:check_item).permit(:name, :pos, :completed)
  end

  def authorize_user
    checklist = Checklist.find(params[:checklist_id])
    checklist_owner = checklist.card.list.board.user
    return if current_user == checklist_owner

    errors = { errors: { message: 'Access denied' } }
    render json: errors, status: :unauthorized
  end
end
