class ThreadController < ApplicationController
  before_action :authenticate

  def show 
    #Select direct messages from mysql database
    @t_direct_messages = TDirectMessage.select("distinct t_direct_messages.id,m_users.name,t_direct_messages.directmsg,t_direct_messages.created_at")
                                      .joins("INNER JOIN t_direct_threads ON t_direct_threads.t_direct_message_id = t_direct_messages.id 
                                              INNER JOIN m_users ON m_users.id = t_direct_messages.send_user_id")
                                      .where("t_direct_threads.m_user_id=?",params[:user_id]).order(created_at: :asc)

    #Select direct thread messages from mysql databases                                  
    @t_direct_threads = TDirectThread.select("t_direct_threads.id as id,m_users.name,t_direct_threads.directthreadmsg,t_direct_threads.t_direct_message_id,t_direct_threads.created_at")
                            .joins("join m_users on t_direct_threads.m_user_id=m_users.id 
                                    join t_direct_messages on t_direct_threads.t_direct_message_id=t_direct_messages.id")
                            .where("t_direct_messages.send_user_id=? or t_direct_messages.receive_user_id=?", 
                            params[:user_id],params[:user_id]).order(id: :asc)
    
    #Select group messages from mysql database                            
    @t_group_messages = TGroupMessage.select("distinct m_users.name, t_group_messages.groupmsg, t_group_messages.id as id,t_group_threads.t_group_message_id, 
                                              t_group_messages.created_at as created_at,m_channels.channel_name")
                                    .joins("INNER JOIN m_channels ON m_channels.id=t_group_messages.m_channel_id
                                            INNER JOIN m_users ON m_users.id = t_group_messages.m_user_id
                                            INNER JOIN t_group_threads ON t_group_threads.t_group_message_id = t_group_messages.id")
                                    .where("t_group_threads.m_user_id= ?",params[:user_id]).order(created_at: :asc)
    
    #Select group thread messages from mysql database                                 
    @t_group_threads = TGroupThread.select("m_users.name, t_group_threads.groupthreadmsg, t_group_threads.id, t_group_threads.t_group_message_id,t_group_threads.created_at")
                                    .joins("INNER JOIN t_group_messages ON t_group_messages.id = t_group_threads.t_group_message_id
                                         INNER JOIN m_users ON t_group_threads.m_user_id = m_users.id ").order(created_at: :asc)
    
    @temp_direct_star_msgids = TDirectStarMsg.select("directmsgid").where("userid = ?", params[:user_id])

    @t_direct_star_msgids = Array.new
    @temp_direct_star_msgids.each { |r| @t_direct_star_msgids.push(r.directmsgid) }                     

    @temp_direct_star_thread_msgids = TDirectStarThread.select("directthreadid").where("userid = ?", params[:user_id])

    @t_direct_star_thread_msgids = Array.new
    @temp_direct_star_thread_msgids.each { |r| @t_direct_star_thread_msgids.push(r.directthreadid) }

    @temp_group_star_msgids = TGroupStarMsg.select("groupmsgid").where("userid = ?", params[:user_id])

    @t_group_star_msgids = Array.new
    @temp_group_star_msgids.each { |r| @t_group_star_msgids.push(r.groupmsgid) }

    @temp_group_star_thread_msgids = TGroupStarThread.select("groupthreadid").where("userid = ?", params[:user_id])

    @t_group_star_thread_msgids = Array.new
    @temp_group_star_thread_msgids.each { |r| @t_group_star_thread_msgids.push(r.groupthreadid) }

    data = {
      t_direct_messages: @t_direct_messages,
      t_direct_threads: @t_direct_threads,
      t_group_messages: @t_group_messages,
      t_group_threads: @t_group_threads,
      t_direct_star_msgids: @t_direct_star_msgids,
      t_direct_star_thread_msgids: @t_direct_star_thread_msgids,
      t_group_star_msgids: @t_group_star_msgids,
      t_group_star_thread_msgids: @t_group_star_thread_msgids
    }
    render json: data
  end
end
