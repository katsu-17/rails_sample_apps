class Notification < ApplicationRecord
  belongs_to :user
  validates  :notification_type, presence: true

  enum notification_type: { first_login: 'first_login', follow: 'follow', multiple_follows: 'multiple_follows' }
end
