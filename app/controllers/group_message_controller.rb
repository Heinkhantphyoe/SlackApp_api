class GroupMessageController < ApplicationController
  before_action :authenticate
  def show 

    @t_group_message = TGroupMessage.new
    @t_group_message.groupmsg = params[:message]
    @t_group_message.m_user_id = params[:user_id]
    @t_group_message.m_channel_id = params[:s_channel_id]
    @t_group_message.save
    
     mention_names = params[:mention_name]

    mention_names.each do |mention_name|
      mention_name[0] = ''
      @memtion_user = MUser.find_by(name: mention_name)
  
      unless @memtion_user.nil?
        @t_group_mention_msg = TGroupMentionMsg.new
        @t_group_mention_msg.userid = @memtion_user.id
        @t_group_mention_msg.groupmsgid = @t_group_message.id
        @t_group_mention_msg.save
      end
    end
    
    @t_user_channels = TUserChannel.where(channelid: params[:s_channel_id])

    @t_user_channels.each do |u_channel|
      if u_channel.userid != params[:user_id]
        u_channel.message_count =  u_channel.message_count + 1
        temp_msgid = ""

        unless u_channel.unread_channel_message.nil?
          u_channel.unread_channel_message.split(",").each do |u_message|
            temp_msgid += u_message
            temp_msgid += ","
          end
        end
        temp_msgid += @t_group_message.id.to_s

        u_channel.unread_channel_message = temp_msgid
        TUserChannel.where(id: u_channel.id).update_all(message_count: u_channel.message_count, unread_channel_message: u_channel.unread_channel_message )
      end
    end
  
    MUser.joins("INNER JOIN t_user_channels on t_user_channels.userid = m_users.id 
          INNER JOIN m_channels ON m_channels.id = t_user_channels.channelid")
      .where("m_channels.m_workspace_id = ? and m_channels.id = ?",
      params[:workspace_id], params[:s_channel_id]).where.not("m_users.id = ?", params[:user_id])
      .update_all(remember_digest: "1")

    @m_channel_users = MUser.joins("INNER JOIN t_user_channels on t_user_channels.userid = m_users.id 
                            INNER JOIN m_channels ON m_channels.id = t_user_channels.channelid")
                            .where("m_users.member_status = 1 and m_channels.m_workspace_id = ? and m_channels.id = ?",
                            params[:workspace_id], params[:s_channel_id])
                            .where.not("m_users.id = ?", params[:user_id])
            
    @m_channel_users.each do |user|
      MUser.where(id: user.id).update_all(remember_digest: "1")
    end
    render json:@t_group_message, status: :ok

    @m_channel = MChannel.find_by(id: params[:s_channel_id])
  end


def deletemsg
  gpthread=TGroupThread.select("id").where(t_group_message_id: params[:id])

  gpthread.each do|gpthread|
    TGroupStarThread.where(groupthreadid: gpthread.id).destroy_all
    TGroupMentionThread.where(groupthreadid: gpthread.id).destroy_all
    TGroupThread.find_by(id: gpthread.id).destroy
  end

    TGroupStarMsg.where(groupmsgid: params[:id]).destroy_all
    TGroupMentionMsg.where(groupmsgid: params[:id]).destroy_all
    TGroupMessage.find_by(id: params[:id]).delete

    @t_user_channels = TUserChannel.where(channelid: params[:s_channel_id])

    @t_user_channels.each do |u_channel|
      if u_channel.userid != params[:s_channel_id]
        u_channel.message_count =  u_channel.message_count - (gpthread.size + 1)

        if u_channel.message_count < 0
          TUserChannel.where(id: u_channel.id).update_all(message_count: 0)
        else
          TUserChannel.where(id: u_channel.id).update_all(message_count: u_channel.message_count)
        end
      end
    end
    render json: "Deleted", status: :ok

    # @m_channel = MChannel.find_by(id: 11)
  end
    
  

  def showthread         
    @t_group_thread = TGroupThread.new
    @t_group_thread.groupthreadmsg = params[:threadmsg]
    @t_group_thread.t_group_message_id = params[:s_group_message_id]
    @t_group_thread.m_user_id = params[:user_id]
    @t_group_thread.save

    mention_names = params[:mention_name]

    mention_names.each do |mention_name|

    mention_name[0] = ''
    @mention_user = MUser.find_by(name: mention_name)

    unless @mention_user.nil?
      @t_group_mention_thread = TGroupMentionThread.new
      @t_group_mention_thread.userid = @mention_user.id
      @t_group_mention_thread.groupthreadid = @t_group_thread.id
      @t_group_mention_thread.save
    end
  end

    @t_user_channels = TUserChannel.where(channelid: params[:s_channel_id])

    @t_user_channels.each do |u_channel|
      if u_channel.userid != params[:user_id]
        u_channel.message_count =  u_channel.message_count + 1
        
        temp_msgid = ""
        unless u_channel.unread_channel_message.nil?
          arr_msgid = u_channel.unread_channel_message.split(",")
          if !arr_msgid.include? params[:s_group_message_id].to_s
              u_channel.unread_channel_message.split(",").each do |u_message|
                temp_msgid += u_message
                temp_msgid += ","
              end

            u_channel.unread_channel_message = temp_msgid
          end
        end

        temp_msgid += params[:s_group_message_id].to_s 
        TUserChannel.where(id: u_channel.id).update_all(message_count: u_channel.message_count, unread_channel_message: u_channel.unread_channel_message )
      end
    end

    MUser.joins("INNER JOIN t_user_channels ON t_user_channels.userid = m_users.id")
          .where("t_user_channels.id =  ?", params[:s_channel_id])
          .where.not("m_users.id = ?", params[:user_id]).update_all(remember_digest: "1")

    @m_channel_users = MUser.joins("INNER JOIN t_user_channels on t_user_channels.userid = m_users.id 
          INNER JOIN m_channels ON m_channels.id = t_user_channels.channelid")
          .where("m_users.member_status = 1 and m_channels.m_workspace_id = ? and m_channels.id = ?",
          params[:workspace_id], params[:s_channel_id])
          .where.not("m_users.id = ?", params[:user_id])
        
    @m_channel_users.each do |user|
          MUser.where(id: user.id).update_all(remember_digest: "1")
    end

    render json: @t_group_thread, status: :created

  end

  def deletethread

     TGroupStarThread.where(groupthreadid: params[:threadmsgid]).destroy_all
     TGroupMentionThread.where(groupthreadid: params[:threadmsgid]).destroy_all
     logger.info('>>>>>>>>>>>')
     logger.info(params[:threadmsgid])
     TGroupThread.find_by(id: params[:threadmsgid]).destroy
     logger.info(TGroupThread.find_by(id: params[:threadmsgid]))
     
     @t_user_channels = TUserChannel.where(channelid: params[:s_channel_id])

     @t_user_channels.each do |u_channel|
       if u_channel.userid != params[:user_id]
         u_channel.message_count =  u_channel.message_count - 1

         if u_channel.message_count < 0
           TUserChannel.where(id: u_channel.id).update_all(message_count: u_channel.message_count)
         else
           TUserChannel.where(id: u_channel.id).update_all(message_count: u_channel.message_count)
         end
       end
     end
   end


end
