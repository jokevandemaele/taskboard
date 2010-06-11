class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_create(user)
  end
end
