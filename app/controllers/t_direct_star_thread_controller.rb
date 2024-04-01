class TDirectStarThreadController < ApplicationController
  before_action :authenticate

  def create
      @t_direct_star_thread = TDirectStarThread.new
      @t_direct_star_thread.userid = params[:user_id]
      @t_direct_star_thread.directthreadid = params[:directthreadid]
      @t_direct_star_thread.save
      render json: true
  end

  def destroy
    TDirectStarThread.find_by(directthreadid: params[:directthreadid], userid: params[:user_id]).destroy
    render json: true
  end


end