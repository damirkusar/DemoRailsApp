class ApplicationController < ActionController::Base
  protect_from_forgery
  attr_accessor :currentTime
  before_filter :setupTime

  def setupTime
    @currentTime = Time.now
  end
end
