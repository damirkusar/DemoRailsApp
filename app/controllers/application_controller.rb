#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
class ApplicationController < ActionController::Base
  protect_from_forgery
  attr_accessor :visitor
  before_filter :current_visits, :authorize
  before_filter :set_i18n_locale_from_params

  protected
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
            "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end
  def default_url_options
    { locale: I18n.locale }
  end


  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, notice: 'Please log in'
    end
  end

  private
  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  private
  def current_visits
    if session[:counter].nil?
      session[:counter] = 0
    end
    session[:counter] += 1
    @visitor = session[:counter]
  end
end