class AuthoritiesController < ApplicationController

  def index
    @authorities = Authority.all
  end

  def show
    @authority = Authority.find(params[:id])
  end

end
