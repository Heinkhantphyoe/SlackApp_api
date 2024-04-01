class TDirectStarMsgController < ApplicationController
  before_action :authenticate

  def create
      @t_direct_star_msg = TDirectStarMsg.new
      @t_direct_star_msg.userid = params[:user_id]
      @t_direct_star_msg.directmsgid = params[:directmsgid]
      @t_direct_star_msg.save
      render json: true
      # @s_user = MUser.find_by(id: params[:s_user_id])
      # redirect_to @s_user
  end

  def destroy
    TDirectStarMsg.find_by(directmsgid: params[:directmsgid]).destroy
    render json: true
    # @user = MUser.find_by(id: session[:s_user_id])
    # redirect_to @user
  end

end
