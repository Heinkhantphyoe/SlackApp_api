class MChannelsController < ApplicationController
  before_action :authenticate
    def show
      #call from ApplicationController for retrieve group message data
      @retrieveGroupMessage = retrieve_group_message

      #call from ApplicationController for retrieve home data
      # @retrieveHome = retrievehome

      data = {
        retrieveGroupMessage: @retrieveGroupMessage
        # retrieveHome: @retrieveHome
      }
      render json: data
    end
    
    def index
      @channels = MChannel.all
      render json: @channels
    end
  
    def create
      status = false
      if params[:m_channel][:channel_name].nil? || params[:m_channel][:channel_status] == ""
        render json: status
      else
        @m_channel = MChannel.new() 
        @m_channel.channel_status = params[:m_channel][:channel_status]
        @m_channel.m_workspace_id = params[:workspace_id]
        @m_channel.channel_name = params[:m_channel][:channel_name]
        
        if @m_channel.save
          @t_user_channel = TUserChannel.new
          @t_user_channel.message_count = 0
          @t_user_channel.unread_channel_message = 0
          @t_user_channel.created_admin = 1
          @t_user_channel.userid =params[:user_id]
          @t_user_channel.channelid = @m_channel.id
      
          if @t_user_channel.save
            status = true
          end
        end
        render json: status
      end

    end


    def edit
      @channel = MChannel.find(params[:id]);
      render json: @channel
    end
  
  def update
    status = false;
    @channel = MChannel.find(params[:id]);
    if @channel.update(channel_params)
      status = true;
      render json: status
    else
      render json: @channel.errors, status: :unprocessable_entity
    end
  end

  def delete
    group_messges = TGroupMessage.where(m_channel_id: params[:s_channel_id])

    group_messges.each do|gmsg|
      gpthread=TGroupThread.select("id").where(t_group_message_id: gmsg.id)

      gpthread.each do|gpthread|
        TGroupStarThread.where(groupthreadid: gpthread.id).destroy_all
        TGroupMentionThread.where(groupthreadid: gpthread.id).destroy_all
        TGroupThread.find_by(id: gpthread.id).destroy
      end

      TGroupStarMsg.where(groupmsgid: gmsg.id).destroy_all
      TGroupMentionMsg.where(groupmsgid: gmsg.id).destroy_all
      TGroupMessage.find_by(id: gmsg.id).delete
    end

    TUserChannel.where(channelid: params[:s_channel_id]).destroy_all
    MChannel.find_by(id: params[:s_channel_id]).delete

    flash[:success] = "Channel Delete Successful."
  end

  def join
    status = false;
     @t_user_channel = TUserChannel.new
     @t_user_channel.message_count = 0
     @t_user_channel.unread_channel_message = 0
     @t_user_channel.created_admin = 0
     @t_user_channel.userid = params[:userid]
     @t_user_channel.channelid = params[:s_channel_id]
     @t_user_channel.save
     @m_channel = MChannel.find_by(id: params[:s_channel_id])
     if @t_user_channel.save
       status = true;
       render json: @t_user_channel, status: :ok
     end
   end

   def refresh_group
    r_group_size = params[:r_group_size].to_i
    #check unlogin user
    # checkuser
    if params[:r_group_size].nil?
      r_group_size =  10
    else
      r_group_size +=  10
    end

    render json: r_group_size, status: :ok
  end

    def channel_params
      params.require(:m_channel).permit(:channel_name,:channel_status)
    end
  
end






