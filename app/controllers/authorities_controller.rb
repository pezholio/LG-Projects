class AuthoritiesController < ApplicationController

  def index
    @authorities = Authority.all.order_by(:name.asc)
  end

  def show
    @authority = Authority.find(params[:id])
  end

end
