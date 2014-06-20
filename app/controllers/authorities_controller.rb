class AuthoritiesController < ApplicationController

  def index
    @authorities = Authorities.all
  end

  def show
    @authority = Authorities.new(params[:id])
  end

end
