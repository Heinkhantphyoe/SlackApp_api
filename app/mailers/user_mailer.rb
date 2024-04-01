class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.member_invite.subject
  #
def member_invite(i_user, i_workspace, i_channel)

  

  @i_user = i_user
  @i_workspace = i_workspace
  @i_channel = i_channel

  mail(to: @i_user.email, subject: 'Member Invitation')
end
end