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

class Devise::RegistrationsController < DeviseController
  def new; end

  # POST /resource
  def create; end

  # GET /resource/edit
  def edit; end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update; end

  # DELETE /resource
  def destroy; end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel; end
end

class Devise::SessionsController < DeviseController
  # GET /resource/sign_in
  def new; end

  # POST /resource/sign_in
  def create; end

  # DELETE /resource/sign_out
  def destroy; end

  protected
  sig { returns(ActionController::Parameters)}
  def sign_in_params; end
end

class Devise::UnlocksController< DeviseController
end
