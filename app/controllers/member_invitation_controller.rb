class MemberInvitationController < ApplicationController
  # before_action: authenticate
  
  def invite 

    # already_member_status = false 
    # is_email_blank = false 
    # is_channelid_blank = false 
    # success_message = false

    error = nil

    @user = MUser.joins("INNER JOIN t_user_workspaces ON t_user_workspaces.userid = m_users.id").where("t_user_workspaces.workspaceid = ? and m_users.email = ?", params[:workspace_id], params[:email])
    
    if @user.size > 0
      # already_member_status = true 
      # flash[:danger] = "Email is already member."
      # redirect_to memberinvite_url
      error = 'Email is already member'
      
    else
      if params[:channelid].nil? || params[:channelid] == ""
        # is_channelid_blank = true
        # flash[:danger] = "Please Select Channel."
        # redirect_to memberinvite_url
        error = 'Please Select Channel.'
        
      elsif params[:email].nil? || params[:email] == ""
        # is_email_blank = true 
        # flash[:danger] = "Please Enter Email."
        # redirect_to memberinvite_url
        error = 'Please Enter Email.'
        
      else
        @i_user = MUser.new
        @i_user.email = params[:email]
        @i_channel = MChannel.find_by(id: params[:channelid])
        @i_workspace = MWorkspace.find_by(id: params[:workspace_id])

        UserMailer.member_invite(@i_user, @i_workspace, @i_channel).deliver_now
        # success_message = true
        # flash[:info] = "Invitation is success."
        # redirect_to home_url
      end

    end 
    # render json: {already_member_status:, is_channelid_blank: , is_email_blank: , success_message: }, status: :ok

    render json: {error: }, status: :ok
   
  end
end
