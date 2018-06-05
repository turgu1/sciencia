class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  before_action :authenticate_user!

  def document_selected?(d, selection_params)
    # puts("--> #{all}(#{all.class.name}, #{from_selection}, #{fyear}, #{fmonth}, #{selection}")
    return true if selection_params[:all]
    if selection_params[:from_selection]
      return !selection_params[:selection].index(d.id).nil?
    else
      return ((d.year > selection_params[:from_year]) || ((d.year == selection_params[:from_year]) && (d.month >= selection_params[:from_month])))
    end
  end


end
