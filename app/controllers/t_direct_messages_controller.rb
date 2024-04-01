class TDirectMessagesController < ApplicationController
  before_action :authenticate

  def show
    render json: retrieve_direct_thread
  end
end
