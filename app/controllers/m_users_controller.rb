class MUsersController < ApplicationController
  before_action :authenticate, only: %i[show]
  def show    
    # authenticate   
    render json: retrieve_direct_message
  end

  def new
    @m_user = MUser.new
  end

  def create
    Rails.logger.info('invite_workspaceid')
    Rails.logger.info (params[:invite_workspaceid])
    @m_user = MUser.new
    @m_user.name = params[:name]
    @m_user.email = params[:email]
    @m_user.password = params[:password]
    @m_user.password_confirmation = params[:password_confirmation]
    @m_user.profile_image = params[:profile_image]
    @m_user.remember_digest = params[:remember_digest]
    @m_user.admin = params[:admin]
    # @m_user.name = params[:m_user][:name]
    # @m_user.email = params[:m_user][:email]
    # @m_user.password = params[:m_user][:password]
    # @m_user.password_confirmation = params[:m_user][:password_confirmation]
    # @m_user.profile_image = params[:m_user][:profile_image]
    # @m_user.remember_digest = params[:m_user][:remember_digest]
    # @m_user.admin = params[:m_user][:admin]
    @m_user.member_status = 1
    @m_user.active_status = 0
    @m_user.save
    @m_workspace = MWorkspace.new
    @m_workspace.workspace_name = @m_user.remember_digest
    @m_channel = MChannel.new
  

    @m_channel.channel_name = @m_user.profile_image
    @m_channel.channel_status = 1
    @m_user.member_status = 1
    status = true
    @t_workspace = MWorkspace.find_by(id: params[:invite_workspaceid])
    if status &&  @m_user.save
      MUser.where(id: @m_user.id).update_all(remember_digest: nil, profile_image: nil)
    else
      status = false
    end
    if(@t_workspace.nil?)
      if status && @m_workspace.save
      else
        status = false
      end
    else
      @m_workspace = @t_workspace
    end
    @t_user_workspace = TUserWorkspace.new
    @t_user_workspace.userid = @m_user.id
    @t_user_workspace.workspaceid = @m_workspace.id
    if status && @t_user_workspace.save
    else
      status = false
    end
    @t_user_channel = TUserChannel.new
    @t_channel = MChannel.find_by(channel_name: @m_channel.channel_name, m_workspace_id: @m_workspace.id)
    if(@t_channel.nil?)
      @t_user_channel.created_admin = 1
      @m_channel.m_workspace_id = @m_workspace.id
      if status && @m_channel.save
      else
        status = false
      end
    else
      @t_user_channel.created_admin = 0
      @m_channel = @t_channel
    end
    @t_user_channel.message_count = 0
    @t_user_channel.unread_channel_message = 0
    @t_user_channel.userid = @m_user.id
    @t_user_channel.channelid = @m_channel.id
    if status && @t_user_channel.save
    else
      status = false
    end
    if(status)
      render json: {message: 'Sign up complete'}, status: :created
    else
      if params[:m_user][:invite_workspaceid].present?
        data = {
          # message: "nil",
          workspace_name: @t_workspace.workspace_name,
          channel_name: @t_channel.channel_name,
          email: @m_user.email,
          error: @m_user.errors.full_messages
        }
        render json: data
      else
        Rails.logger.info("No")
        data = {
          # message: "nil",
          error: @m_user.errors.full_messages
        }
        Rails.logger.info(data)
        render json: data
      end
    end
  end

  def refresh_direct
    r_direct_size = params[:r_direct_size].to_i
    #check unlogin user
    # checkuser

    logger.info("r_direct_size...")
    logger.info(r_direct_size)

    if params[:r_direct_size].nil?
      r_direct_size =  10
    else
      r_direct_size +=  10
      logger.info("r_direct_size...")
      logger.info(r_direct_size)
    end

    retrieve_direct_message
    render json: r_direct_size, status: :ok

    #call from ApplicationController for retrieve direct message data

    #call from ApplicationController for retrieve home data
    # retrievehome
  end

  def confirm 
    # authenticate
    @m_workspace = MWorkspace.find_by(id: params[:workspaceid])
    @m_channel = MChannel.find_by(id: params[:channelid])
    # session[:invite_workspaceid] = params[:workspaceid]

    @m_user = MUser.new
		@m_user.email = params[:email]
		@m_user.remember_digest = @m_workspace.workspace_name
		@m_user.profile_image = @m_channel.channel_name
  end
  

  def invitation_confirm 
    # authenticate
    Rails.logger.info('invitation_confirm .........................')
    Rails.logger.info(params[:workspace_id])
    Rails.logger.info(params[:channel_id])
    @m_workspace = MWorkspace.find_by(id: params[:workspace_id])
		@m_channel = MChannel.find_by(id: params[:channel_id])
    Rails.logger.info('invi con.......m_channel')
    Rails.logger.info(@m_channel)

		@m_user = MUser.new
		@m_user.email = params[:email]
		@m_user.remember_digest = @m_workspace.workspace_name
		@m_user.profile_image = @m_channel.channel_name
		render json: {email: @m_user.email, channel_name: @m_channel.channel_name, workspace_name: @m_workspace.workspace_name}, status: :ok
  end

  def user_params
    params.require(:m_user).permit(:name, :email, :password,
    :password_confirmation, :profile_image, :remember_digest, :admin)
  end

end
