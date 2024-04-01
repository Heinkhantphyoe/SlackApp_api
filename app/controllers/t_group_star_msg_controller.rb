class TGroupStarMsgController < ApplicationController
  before_action :authenticate

  def create
    
      @t_group_star_msg = TGroupStarMsg.new
      @t_group_star_msg.userid = params[:user_id]
      @t_group_star_msg.groupmsgid = params[:msgid]
      @t_group_star_msg.save
      render json: @t_group_star_msg, status: :created
      # @m_channel = MChannel.find_by(id: 1)
  end

  def destroy
      TGroupStarMsg.find_by(groupmsgid: params[:msgid], userid: params[:user_id]).destroy
      # @m_channel = MChannel.find_by(id:11) 
  end
end
