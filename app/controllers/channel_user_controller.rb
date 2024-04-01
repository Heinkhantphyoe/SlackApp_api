class ChannelUserController < ApplicationController
  before_action :authenticate
  def show
    @w_users = MUser.joins("INNER JOIN t_user_workspaces ON t_user_workspaces.userid = m_users.id")
    .where("t_user_workspaces.workspaceid = ?", params[:workspace_id])

    @c_users = MUser.select("m_users.id, m_users.name, m_users.email, t_user_channels.created_admin")
        .joins("INNER JOIN t_user_channels ON t_user_channels.userid = m_users.id")
        .where("t_user_channels.channelid = ?", params[:s_channel_id]).order(created_admin: :desc)
        logger.info('@c_users>>>>>>>>>>>>>>>>>>>>>>>>')
        logger.info(@c_users)
    # @temp_c_users_id = MUser.select("m_users.id").joins("INNER JOIN t_user_channels ON t_user_channels.userid = m_users.id")
        #                         .where("t_user_channels.channelid = ?", session[:s_channel_id]).order(created_admin: :desc)
    @c_users_id = Array.new
    @c_users.each { |r| @c_users_id.push(r.id) }
    @s_channel = MChannel.find_by(id: params[:s_channel_id])
    #call from ApplicationController for retrieve home data
    # home = retrievehome
    data = {
      w_users: @w_users,
      c_users: @c_users,
      c_users_id: @c_users_id,
      s_channel: @s_channel
      # home: home
    }
    render json: data
  end
  
  def destroy
    @user_delete = TUserChannel.find_by(userid: params[:user_id], channelid: params[:s_channel_id]).destroy
    render json: "Deleted"
  end

  def create
    status = false;

    @t_user_channel = TUserChannel.new
    @t_user_channel.message_count = 0
    @t_user_channel.unread_channel_message = 0
    @t_user_channel.created_admin = 0
    @t_user_channel.userid = params[:user_id]
    @t_user_channel.channelid = params[:s_channel_id]
    if @t_user_channel.save
      status = true; 
      render json: @t_user_channel, status: :ok
    end
  end
  
end
