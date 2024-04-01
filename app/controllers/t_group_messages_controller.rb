class TGroupMessagesController < ApplicationController
  before_action :authenticate

  def show
      # params[:s_group_message_id] =  params[:msgid]

      #call from ApplicationController for retrieve group thread data
      @retrieve_group_thread = retrieve_group_thread

    

      #call from ApplicationController for retrieve home data
      # @retrieve_home = retrievehome

      data = {
        retrieveGroupThread: @retrieve_group_thread
        # retrieveHome: @retrieve_home
      }
      render json: data
    end
end
