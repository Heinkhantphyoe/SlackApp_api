class StarListsController < ApplicationController
  before_action :authenticate

  def show
    @t_direct_messages=TDirectMessage.select("t_direct_messages.id,t_direct_messages.directmsg,t_direct_messages.created_at,m_users.name")
                                    .joins("INNER JOIN t_direct_star_msgs ON t_direct_messages.id=t_direct_star_msgs.directmsgid
                                            INNER JOIN m_users ON m_users.id=t_direct_messages.send_user_id")
                                    .where("t_direct_star_msgs.userid=?",params[:user_id]).order(id: :asc)

    @t_direct_threads=TDirectThread.select("t_direct_threads.id,t_direct_threads.directthreadmsg,t_direct_threads.created_at,m_users.name")
                                            .joins("INNER JOIN t_direct_star_threads ON t_direct_threads.id=t_direct_star_threads.directthreadid
                                            INNER JOIN m_users ON m_users.id=t_direct_threads.m_user_id")
                                            .where("t_direct_star_threads.userid=?",params[:user_id]).order(id: :asc)

    @t_group_messages=TGroupMessage.select("t_group_messages.id,t_group_messages.groupmsg,t_group_messages.created_at,m_users.name,m_channels.channel_name")
                                            .joins("INNER JOIN t_group_star_msgs ON t_group_messages.id=t_group_star_msgs.groupmsgid
                                            INNER JOIN m_users ON  t_group_messages.m_user_id=m_users.id
                                            INNER JOIN m_channels ON t_group_messages.m_channel_id = m_channels.id")
                                            .where("t_group_star_msgs.userid=?",params[:user_id]).order(id: :asc)

    @t_group_threads=TGroupThread.select("t_group_threads.id,t_group_threads.groupthreadmsg,t_group_threads.created_at,m_users.name,m_channels.channel_name") 
                                        .joins("INNER JOIN t_group_star_threads ON t_group_threads.id=t_group_star_threads.groupthreadid
                                          INNER JOIN t_group_messages ON t_group_messages.id=t_group_threads.t_group_message_id
                                          INNER JOIN m_users ON m_users.id=t_group_threads.m_user_id
                                          INNER JOIN m_channels ON t_group_messages.m_channel_id = m_channels.id")            
                                          .where("t_group_star_threads.userid=?",params[:user_id]).order(id: :asc)  
                                          
    data = {
      t_direct_messages: @t_direct_messages,
      t_direct_threads: @t_direct_threads,
      t_group_messages: @t_group_messages,
      t_group_threads: @t_group_threads
    }

    render json: data
  end
end
