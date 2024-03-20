class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        if user.first_logged_in_at.nil?
          create_notification(user)
          user.first_logged_in_at = Time.current
          user.save
        end
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def create_notification(user)
    notification = Notification.new(user_id: user.id,
                                    notification_type: Notification.notification_types[:first_login])
    notification.save
  end
end
