class ChangePasswordController < ApplicationController
  before_action :authenticate
  def new
    render json: retrievehome
  end

  def update 

    # is_password_blank = false 
    # is_password_confirmation_blank = false 
    # password_equal_status = false 
    # success_status = false

    error = ''

    @m_user = MUser.new(user_params)
    password = params[:m_user][:password]
    password_confirmation = params[:m_user][:password_confirmation]

    if password == "" || password.nil?
      # is_password_blank = true 
      error = "Password can't be blank!"

    elsif password_confirmation == "" || password_confirmation.nil?
      # is_password_confirmation_blank = true
      error = "Password confirmation can't be blank!"

    elsif password != password_confirmation
      # password_equal_status = true
      error = "Password and Password confirmation must be equal!"
  
    else 
      MUser.where(id: params[:user_id]).update_all(password_digest: @m_user.password_digest)
      # success_status = true 
      
    end
    # render json: {is_password_blank: , is_password_confirmation_blank:, password_equal_status:, success_status:}, status: :ok
    render json: {error:}, status: :ok
  end

  def user_params
    params.require(:m_user).permit(:name, :email, :password,
    :password_confirmation, :profile_image, :remember_digest, :admin)
  end
end
