# add top-level class documentation
class PagesController < ApplicationController
  before_filter :authenticate_user!

  def show
    render json: current_user.active_task.pages.find(params[:id])
  end

  def update
    page = current_user.active_task.pages.find(params[:id])
    page.update(text: params[:text])

    render json: current_user.active_task
  end
end
