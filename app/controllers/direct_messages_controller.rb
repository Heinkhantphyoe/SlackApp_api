#Slack System
#Direct Message Controller 
#Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
#@Since 27/06/2019
#Version 1.0.0

class DirectMessagesController < ApplicationController
  before_action :authenticate
  def show
      @t_direct_message = TDirectMessage.new
      @t_direct_message.directmsg = params[:message]
      @t_direct_message.send_user_id = params[:send_user_id]
      @t_direct_message.receive_user_id = params[:receive_user_id]
      @t_direct_message.read_status = 0

    if params[:message] == "" || params[:send_user_id] == "" || params[:receive_user_id] == ""
      render json: "Nil Error"
    else
      @t_direct_message.save
      MUser.where(id: params[:s_user_id]).update_all(remember_digest: "1")
      render json: "Message Created"
    end
      
      # @user = MUser.find_by(id: params[:s_user_id])
  end

  def showthread
    @t_direct_thread = TDirectThread.new
    @t_direct_thread.directthreadmsg = params[:directthreadmsg]
    @t_direct_thread.t_direct_message_id = params[:t_direct_message_id]
    @t_direct_thread.m_user_id = params[:m_user_id]
    @t_direct_thread.read_status = 0
    @t_direct_thread.save
    MUser.where(id: params[:s_user_id]).update_all(remember_digest: "1")
    render json: true
  end

  def deletemsg
    directthread=TDirectThread.select("id").where(t_direct_message_id: params[:id])
    directthread.each do|directthread|
        TDirectStarThread.where(directthreadid: directthread["id"]).destroy_all
        TDirectThread.find_by(id: directthread["id"]).destroy
    end
    TDirectStarMsg.where(directmsgid: params[:id]).destroy_all
    TDirectMessage.find_by(id: params[:id]).destroy
    @user = MUser.find_by(id: 2)
    render json: "Message Deleted"
  end

  def deletethreadmsg
    TDirectStarThread.where(directthreadid: params[:directthreadid]).destroy_all
    TDirectThread.find_by(id: params[:directthreadid]).destroy
    # @user = MUser.find_by(id: 2)
    render json: "Thread Message Deleted"
  end
end
