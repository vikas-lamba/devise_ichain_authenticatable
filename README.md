Devise iChain Authenticatable
=============================

iChain based authentication for the
[Devise](http://github.com/plataformatec/devise) authentication framework.
The plugin adds two new modules to Devise: `ichain_autenticatable` and
`ichain_registerable`. This plugin is compatible with Database Authenticatable,
so users in your application can be authenticated with both mechanism if
desired.

Requirements
------------

The plugin should be compatible with Ruby 1.8.7, 1.9 and 2.0 (tested with
1.9.3 and 2.0.0).

In the same way, it should work with any version of Devise equal or greater than 2.2
and with any version of Rails equal or greater than 3.2 (tested with Devise 2.2
on Rails 3.2 and with Devise 3.1 on Rails 4).

Reporting of success stories with other setups would be highly appreciated.

Installation and basic setup
---------------------------

First of all, install Devise following the great documentation available in
[its official website](http://github.com/plataformatec/devise). Then, just add
the following line to your Gemfile and run the bundle command.

    gem "devise_ichain_authenticatable"

Only two changes are required in your user model. First, you obviously need to
add the new modules to the devise call. In the other hand, you need to provide
a way to link the iChain usernames to your application users by implementing
the `for_ichain_username` class method. For example:

```ruby
class User < ActiveRecord::Base
  devise :ichain_authenticatable, :ichain_registerable

  def self.for_ichain_username(username, attributes)
    if (user = find_by(login: username))
      user.update_column(email: attributes[:email]) if user.email != attributes[:email]
    else
      create(login: username, email: attributes[:email])
    end
  end
end
```

After performing a valid iChain authentication, the plugin will call the
`from_ichain_username` class method of your model
passing two parameters: the username validated by iChain and a hash of
additional parameters defined in the configuration of your iChain proxy
(see `config.ichain_attributes_header` below).
The method is expected to return a valid user object. If the returned
value is evaluated to false or nil, the authentication will fail.

In the example, an ActiveRecord based model is used, but the plugin will
work with any storage backend as long as it's supported by Devise and
the `from_ichain_username` is properly implemented.

Finally, you'll need to add some configuration to your
`config/initializers/devise.rb` in order to tell your app how to talk
to your iChain proxy.

```ruby
Devise.setup do |config|
 ...
 # You will always need to set this parameter.
 config.ichain_base_url = "https://my.application.org"

 # Paths (relative to ichain_base_url) used by your proxy
 # config.ichain_login_path = "ICSLogin/"
 # config.ichain_registration_path = "ICSLogin/auth-up/"
 # config.ichain_logout_path = "cmd/ICSLogout/"

 # The header used by your iChain proxy to pass the username.
 # config.ichain_username_header = "HTTP_X_USERNAME"

 # Additional parameters, beyond the username, provided by the iChain proxy.
 # HTTP_X_EMAIL is expected by default. Set to {} if no additional attributes
 # are configured in the proxy.
 # config.ichain_attributes_header = {:email => "HTTP_X_EMAIL"}

 # Configuration options for requests sent to the iChain proxy
 # config.ichain_context = "default"
 # config.ichain_proxypath = "reverse"

 # Activate the test mode, useful when no real iChain is present, like in
 # testing and development environments
 # config.ichain_test_mode = false

 # In test mode, you can skip asking for the user information by always
 # forcing the following username. The user will be permanently signed in.
 # config.ichain_force_test_username = "testuser"

 # In test mode, force the following additional attributes
 # config.ichain_force_test_attributes = {:email => "testuser@example.com"}
end
```

Helpers
-------

This plugin provides the expected URL helpers, analogous to those provided by
Database Authenticable and Registerable. For example, for a model called User,
the following helpers would be available: `new_user_ichain_session_path`,
`destroy_user_ichain_session_path`, `new_ichain_registration_path`...

Test mode
---------

This gem provides a test mode, extremely useful during the development
phase, in which an iChain proxy is not usually configured or even available.
```ichain_registerable```will have no effect if test mode is enabled.

By default, if the test mode is enabled in the configuration file, anytime
authentication is required, a very simple form asking for the username and the
additional parameters will be displayed. The entered values will be completely
trusted with no check and stored in the Rails' session.

In some situations this approach is not useful, either because the application
lacks sessions' management and/or user interface (for example, applications
based on [rails-api](https://github.com/rails-api/rails-api)), either because
you simply want to skip asking for the test user information. In those
cases, a username and/or a set of additional attributes can be forced using the
```ichain_force_test_username``` and ```ichain_force_test_attributes```
configuration options. If ```ichain_force_test_username``` is set, the username
will be used in every single request, which means that the user will be
permanently signed in.

Contact
-------

Ancor González Sosa

* http://github.com/ancorgs
* ancor@suse.de

License
-------

The Redmine iChain Plugin is licensed under the MIT License (MIT-LICENSE.txt).

Copyright (c) 2013 Ancor González Sosa
