require 'devise'
require 'devise_ichain_authenticatable/routes'
require 'devise_ichain_authenticatable/strategy'
require 'devise_ichain_authenticatable/models'
require 'devise_ichain_authenticatable/rails'

module Devise

  autoload :IchainFailureApp, 'devise/ichain_failure_app'

  # Configuration params
  @@ichain_test_mode = false
  @@ichain_base_url = nil
  @@ichain_context = "default"
  @@ichain_proxypath = "reverse"
  @@ichain_username_header = "HTTP_X_USERNAME"
  @@ichain_attribute_headers = {:email => "HTTP_X_EMAIL"}

  mattr_accessor :ichain_test_mode, :ichain_base_url, :ichain_context,
    :ichain_proxypath, :ichain_username_header, :ichain_attribute_headers
end

Devise.add_module :ichain_authenticatable,
  :strategy => true,
  :controller => :ichain_sessions,
  :route => {:ichain_session => [nil, :new, :test, :destroy]}

Devise.add_module :ichain_registerable,
  :strategy => false,
  :controller => :ichain_registrations,
  :route => {:ichain_registration => [nil, :new, :edit]}