class UserManageController < ApplicationController
  before_action :authenticate
  def usermanage 
    @user_manages_activate = MUser.select("m_users.id,name,email,member_status").joins("join t_user_workspaces on t_user_workspaces.userid = m_users.id")
    .where("t_user_workspaces.userid = m_users.id and admin <> 1 and member_status = 1 and t_user_workspaces.workspaceid = ?",params[:workspace_id])

    @user_manages_deactivate = MUser.select("m_users.id,name,email,member_status").joins("join t_user_workspaces on t_user_workspaces.userid = m_users.id")
    .where("t_user_workspaces.userid = m_users.id and admin <> 1 and member_status = 0 and t_user_workspaces.workspaceid = ?",params[:workspace_id])

    @user_manages_admin = MUser.select("name,email").joins("join t_user_workspaces on t_user_workspaces.userid = m_users.id")
    .where("t_user_workspaces.userid = m_users.id and m_users.admin = 1 and t_user_workspaces.workspaceid = ?",params[:workspace_id])

    data = {
      user_manages_activate: @user_manages_activate,
      user_manages_deactivate: @user_manages_deactivate,
      user_manages_admin: @user_manages_admin
    }
    Rails.logger.info("Data")
    Rails.logger.info(params[:workspace_id])
    Rails.logger.info(data)

    render json: data, status: :ok
  end

  def edit 
    MUser.where(id: params[:id]).update_all(member_status: 0)
    render json: {status: 1}, status: :ok
  end

  def update 
    MUser.where(id: params[:id]).update_all(member_status: 1)
    render json: {status: 1}, status: :ok
  end
end
