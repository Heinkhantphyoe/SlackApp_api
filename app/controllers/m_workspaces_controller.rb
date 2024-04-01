class MWorkspacesController < ApplicationController
  
  def new 
    @m_user = MUser.new
  end

end
