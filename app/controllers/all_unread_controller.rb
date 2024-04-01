class AllUnreadController < ApplicationController
  before_action :authenticate
  def show
    #Select unread direct messages from mysql database
    @t_direct_messages=TDirectMessage.select("t_direct_messages.id,t_direct_messages.directmsg,t_direct_messages.created_at,m_users.name")
        .joins("INNER JOIN m_users ON m_users.id = t_direct_messages.send_user_id")
        .where("t_direct_messages.send_user_id=m_users.id and t_direct_messages.read_status=0 and
            t_direct_messages.receive_user_id=?",params[:user_id]) 

    #Select unread direct thread messages from mysql database        
    @t_direct_threads=TDirectThread.select("t_direct_threads.t_direct_message_id,
            t_direct_threads.directthreadmsg,t_direct_threads.created_at,m_users.name")
        .joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id
            INNER JOIN m_users ON m_users.id = t_direct_threads.m_user_id")
        .where("t_direct_messages.id=t_direct_threads.t_direct_message_id and t_direct_threads.read_status=0 and t_direct_threads.m_user_id=m_users.id 
            and t_direct_threads.m_user_id <> ?",params[:user_id])

    #Select unread group messages from mysql database        
    @temp_user_channelids=TUserChannel.select("unread_channel_message").where("message_count > 0 and userid=?",params[:user_id])

    
    @t_user_channelids = Array.new
    @temp_user_channelids.each do |u_channel|
        unless u_channel.unread_channel_message.nil?
            @t_user_channelids = u_channel.unread_channel_message.split(",")
        end
    end

    logger.info("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    logger.info(@t_user_channelids);

    @t_group_messages = TGroupMessage.select("t_group_messages.id,t_group_messages.groupmsg,t_group_messages.created_at,m_users.name,m_channels.channel_name, (select count(*) from t_group_threads where t_group_threads.t_group_message_id = t_group_messages.id) as count, m_channels.channel_name")
    .joins("INNER JOIN m_users ON m_users.id = t_group_messages.m_user_id
    INNER JOIN m_channels ON t_group_messages.m_channel_id=m_channels.id")
    logger.info('>>>>>>>>>>>>>>')
    logger.info(@t_group_messages)

    data = {
      t_direct_messages: @t_direct_messages,
      t_direct_threads: @t_direct_threads,
      t_user_channelids: @t_user_channelids,
      t_group_messages: @t_group_messages
    }
    render json: data
   
  end
end
