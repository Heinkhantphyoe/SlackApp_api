class TGroupStarThreadController < ApplicationController
  before_action :authenticate

  def create  
    @t_group_star_thread = TGroupStarThread.new
    @t_group_star_thread.userid = params[:user_id]
    @t_group_star_thread.groupthreadid = params[:threadmsgid]
    @t_group_star_thread.save
    
    @t_group_message = TGroupMessage.find_by(id: params[:threadmsgid] )
    render json: @t_group_star_thread, status: :created
  end


  def destroy    
    TGroupStarThread.find_by(groupthreadid: params[:threadmsgid], userid: params[:user_id]).destroy
    render status: :ok
  end
end
