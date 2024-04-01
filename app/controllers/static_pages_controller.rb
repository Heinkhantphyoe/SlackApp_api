class StaticPagesController < ApplicationController 
  def home 
    render json: retrievehome
  end
end