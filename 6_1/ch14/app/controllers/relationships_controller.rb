class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    create_or_update_notification
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def create_or_update_notification
    return if already_created?

    last_notification = Notification.where(user_id: @user.id).order(updated_at: :desc).first
    if last_notification.present? && Time.current <= last_notification.updated_at + 5.minutes
      update_notification(last_notification)
    else
      create_notification
    end
  end

  def already_created?
    Notification.where(user_id: @user.id).where("#{current_user.id} = ANY (follower_ids)").present?
  end

  def update_notification(last_notification)
    follower_ids = last_notification.follower_ids
    follower_ids.push(current_user.id)
    last_notification.update(notification_type: Notification.notification_types[:multiple_follows],
                             follower_ids: follower_ids)
  end

  def create_notification
    notification = Notification.new(user_id: @user.id,
                                    notification_type: Notification.notification_types[:follow],
                                    follower_ids: [current_user.id],
                                    follower_name: current_user.name)
    notification.save
  end
end
