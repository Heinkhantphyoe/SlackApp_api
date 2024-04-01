class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  # HttpStatus
  include HttpStatus
  # UserAuthenticator
  include UserAuthenticator
  def retrieve_direct_message
      logger.info("Retrievee")
      logger.info(params[:id])
      logger.info(params[:user_id])
      logger.info("R_direct_size")
      logger.info(params[:r_direct_size])

      TDirectMessage.where(send_user_id: params[:id], receive_user_id: params[:user_id], read_status: 0).update_all(read_status: 1)
      TDirectThread.joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id").where(
        "(t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? ) || (t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? )", params[:user_id],  params[:id],  params[:id], params[:user_id]
      ).where.not(m_user_id: params[:user_id], read_status: 1).update_all(read_status: 1)
  
      @s_user = MUser.find_by(id: params[:id])
  
      @t_direct_messages = TDirectMessage.select("name, directmsg, t_direct_messages.id as id, t_direct_messages.created_at  as created_at, 
                                            (select count(*) from t_direct_threads where t_direct_threads.t_direct_message_id = t_direct_messages.id) as count")
                                          .joins("INNER JOIN m_users ON m_users.id = t_direct_messages.send_user_id")
                                          .where("(t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? ) 
                                            || (t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? )", 
                                            params[:user_id],  params[:id],  params[:id], params[:user_id]).order(created_at: :desc).limit(params[:r_direct_size])
      @direct = TDirectMessage.all
      @t_direct_messages = @t_direct_messages.reverse
      @temp_direct_star_msgids = TDirectStarMsg.select("directmsgid").where("userid = ?", params[:user_id])
  
      @t_direct_star_msgids = Array.new
      @temp_direct_star_msgids.each { |r| @t_direct_star_msgids.push(r.directmsgid) }
  
      @t_direct_message_dates = TDirectMessage.select("distinct DATE(created_at) as created_date")
                                              .where("(t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? ) 
                                              || (t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? )", 
                                              params[:user_id],  params[:id],  params[:id], params[:user_id])
      
      @t_direct_message_datesize = Array.new
      @t_direct_messages.each{|d| @t_direct_message_datesize.push(d.created_at.strftime("%F").to_s)}

      data ={
          s_user: @s_user,
          t_direct_messages: @t_direct_messages,
          t_direct_star_msgids: @t_direct_star_msgids,
          t_direct_message_dates: @t_direct_message_dates,
          t_direct_message_datesize: @t_direct_message_datesize
          }
    return data
  end

  def retrieve_direct_thread
    @s_user = MUser.find_by(id: params[:s_user_id])
        
    @t_direct_message = TDirectMessage.find_by(id: params[:t_direct_message_id])
    @send_user = MUser.find_by(id: @t_direct_message.send_user_id)

    TDirectThread.where.not(m_user_id: params[:user_id], read_status: 1).update_all(read_status: 1)

    @t_direct_threads = TDirectThread.select("name, directthreadmsg, t_direct_threads.id as id, t_direct_threads.created_at  as created_at")
                .joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id
                        INNER JOIN m_users ON m_users.id = t_direct_threads.m_user_id")
                .where("t_direct_threads.t_direct_message_id = ?", params[:t_direct_message_id]).order(id: :asc)
    
    @temp_direct_star_thread_msgids = TDirectStarThread.select("directthreadid").where("userid = ?", params[:user_id])

    @t_direct_star_thread_msgids = Array.new
    @temp_direct_star_thread_msgids.each { |r| @t_direct_star_thread_msgids.push(r.directthreadid) }
    
    data = {
      s_user: @s_user,
      t_direct_message: @t_direct_message,
      send_user: @send_user,
      t_direct_threads: @t_direct_threads,
      t_direct_star_thread_msgids: @t_direct_star_thread_msgids
    }
    return data
    logger.info(data)
  end

  def retrieve_group_message
    @s_channel = MChannel.find_by(id: params[:id])

    @m_channel_users = MUser.joins("INNER JOIN t_user_channels on t_user_channels.userid = m_users.id 
                                    INNER JOIN m_channels ON m_channels.id = t_user_channels.channelid")
                                .where("m_users.member_status = 1 and m_channels.m_workspace_id = ? and m_channels.id = ?",
                                params[:workspace_id], params[:id])

    TUserChannel.where(channelid: params[:id], userid: params[:user_id]).update_all(message_count: 0, unread_channel_message: nil)

    @t_group_messages = TGroupMessage.select("name, groupmsg, t_group_messages.id as id, t_group_messages.created_at as created_at, 
                                            (select count(*) from t_group_threads where t_group_threads.t_group_message_id = t_group_messages.id) as count ")
                                      .joins("INNER JOIN m_users ON m_users.id = t_group_messages.m_user_id")
                                      .where("m_channel_id = ? ", params[:id]).order(created_at: :desc).limit(params[:r_group_size])
    
    @t_group_messages = @t_group_messages.reverse
    @temp_group_star_msgids = TGroupStarMsg.select("groupmsgid").where("userid = ?", params[:user_id])

    @t_group_star_msgids = Array.new
    @temp_group_star_msgids.each { |r| @t_group_star_msgids.push(r.groupmsgid) }
    @u_count = TUserChannel.where(channelid: params[:id]).count
    @t_group_message_dates = TGroupMessage.select("distinct DATE(created_at) as created_date").where("m_channel_id = ? ", params[:id])
    
    @t_group_message_datesize = Array.new
    @t_group_messages.each{|d| @t_group_message_datesize.push(d.created_at.strftime("%F").to_s)}

    data = {
      s_channel: @s_channel,
      m_channel_users: @m_channel_users,
      t_group_messages: @t_group_messages,
      t_group_star_msgids:  @t_group_star_msgids,
      u_count: @u_count,
      t_group_message_dates: @t_group_message_dates,
      t_group_message_datesize:  @t_group_message_datesize
       }
       return data;
  end


  def retrieve_group_thread
    
    @s_channel = MChannel.find_by(id: params[:s_channel_id])

    @m_channel_users = MUser.joins("INNER JOIN t_user_channels on t_user_channels.userid = m_users.id 
                                    INNER JOIN m_channels ON m_channels.id = t_user_channels.channelid")
                                .where("m_users.member_status = 1 and m_channels.m_workspace_id = ? and m_channels.id = ?",
                                params[:workspace_id], params[:s_channel_id])
                                
    TUserChannel.where(channelid: params[:s_channel_id], userid: params[:user_id]).update_all(message_count: 0, unread_channel_message: nil)
    
    @t_group_message = TGroupMessage.find_by(id: params[:s_group_message_id])
    @send_user = MUser.find_by(id: @t_group_message.m_user_id)

    @t_group_threads = TGroupThread.select("name, groupthreadmsg, t_group_threads.id as id, t_group_threads.created_at  as created_at")
                    .joins("INNER JOIN t_group_messages ON t_group_messages.id = t_group_threads.t_group_message_id
                          INNER JOIN m_users ON m_users.id = t_group_threads.m_user_id").where("t_group_threads.t_group_message_id = ?", params[:s_group_message_id]).order(id: :asc)
    
    @temp_group_star_thread_msgids = TGroupStarThread.select("groupthreadid").where("userid = ?", params[:user_id])

    @t_group_star_thread_msgids = Array.new
    @temp_group_star_thread_msgids.each { |r| @t_group_star_thread_msgids.push(r.groupthreadid) }
    
    @u_count = TUserChannel.where(channelid: params[:s_channel_id]).count

    data = {
      s_channel: @s_channel,
      m_channel_users: @m_channel_users,
      t_group_message: @t_group_message,
      send_user: @send_user,
      t_group_threads: @t_group_threads,
      temp_group_star_thread_msgids: @temp_group_star_thread_msgids,
      t_group_star_thread_msgids: @t_group_star_thread_msgids,
      u_count: @u_count
    }
    
    return data;
    
  end

  def retrievehome
    # params[:workspace_id] = 11
    # params[:user_id] = 11
    logger.info("retrievehome")
    logger.info(params[:workspace_id])
    logger.info(params[:user_id])
    @m_workspace = MWorkspace.find_by(id: params[:workspace_id])
    @m_user = MUser.find_by(id: params[:user_id])
    
    @m_users = MUser.joins("INNER JOIN t_user_workspaces ON t_user_workspaces.userid = m_users.id
                            INNER JOIN m_workspaces ON m_workspaces.id = t_user_workspaces.workspaceid")
      .where("m_users.member_status = 1 and m_workspaces.id = ? and m_users.id != ?", params[:workspace_id], params[:user_id])
      logger.info('################')
      logger.info(@m_users)
    @m_channels = MChannel.select("m_channels.id,channel_name,channel_status,t_user_channels.message_count").joins(
      "INNER JOIN t_user_channels ON t_user_channels.channelid = m_channels.id"
    ).where("(m_channels.m_workspace_id = ? and t_user_channels.userid = ?)",params[:workspace_id], params[:user_id]).order(id: :asc)

    @m_p_channels = MChannel.select("m_channels.id,channel_name,channel_status")
      .where("(m_channels.channel_status = 1 and m_channels.m_workspace_id = ?)",params[:workspace_id]).order(id: :asc)
           
    @direct_msgcounts = Array.new

    @m_users.each do |muser|
      @direct_count = TDirectMessage.where(send_user_id: muser.id, receive_user_id: params[:user_id], read_status: 0)
  
      @thread_count = TDirectThread.joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id")
                                    .where("t_direct_threads.read_status = 0 and t_direct_threads.m_user_id = ? and 
                                    ((t_direct_messages.send_user_id = ? and t_direct_messages.receive_user_id = ?) || 
                                    (t_direct_messages.send_user_id = ? and t_direct_messages.receive_user_id = ?))", 
                                    muser.id, muser.id, session[:user_id], session[:user_id], muser.id)
      @direct_msgcounts.push( @direct_count.size +  @thread_count.size)
    end

    @all_unread_count = 0
    @m_channels.each do |c|
      @all_unread_count += c.message_count
    end

    @direct_msgcounts.each do |c|
      @all_unread_count +=c
    end

    @m_channelsids = Array.new
    @m_channels.each do|m_channel|
      @m_channelsids.push(m_channel.id)
    end

    data = {
      m_user: @m_user,
      email: @m_user.email,
      m_users: @m_users,
      m_workspace: @m_workspace,
      all_unread_count: @all_unread_count,
      m_channels: @m_channels,
      m_p_channels: @m_p_channels,
      count: @count,
      direct_msgcounts: @direct_msgcounts,
      m_channelsids: @m_channelsids
    }
 
  end

end
