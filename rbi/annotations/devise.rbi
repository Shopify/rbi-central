# typed: true

class DeviseController
  protected

  sig {returns(T.untyped)}
  def resource; end

  # Proxy to devise map name
  sig {returns(String)}
  def resource_name; end

  sig {returns(String)}
  def scope_name; end

  # Proxy to devise map class
  sig {returns(T::Class[T.anything])}
  def resource_class; end

  # Returns a signed in resource from session (if one exists)
  sig {returns(T.untyped)}
  def signed_in_resource; end

  # Attempt to find the mapped route for devise based on request path
  sig {returns(T.untyped)}
  def devise_mapping; end

  sig {returns(T.untyped)}
  def navigational_formats; end

  sig {returns(ActionController::Parameters)}
  def resource_params; end

  sig {returns(String)}
  def translation_scope; end
end

class Devise::ConfirmationsController < DeviseController
  def new; end
  # POST /resource/confirmation
  def create; end
  # GET /resource/confirmation?confirmation_token=abcdef
  def show; end
end

class Devise::PasswordsController < DeviseController
 # GET /resource/password/new
  def new; end

  # POST /resource/password
  def create; end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit; end

  # PUT /resource/password
  def update; end
end

class Devise::RegistrationsController< DeviseController
end

class Devise::SessionsController< DeviseController
end

class Devise::UnlocksController< DeviseController
end
