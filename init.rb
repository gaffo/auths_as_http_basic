require File.dirname(__FILE__) + '/lib/http_basic_auth'

ActionController::Base.class_eval do
  include HttpBasicAuth
end