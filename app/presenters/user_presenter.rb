
class UserPresenter
  def initialize(user, current_user, current_account)
    @user = user
    @current_user = current_user
    @current_account = current_account
  end

  def can_edit?
    # admins cant edit owners
    user_is_owner = @user.account_permission?(@current_account, :owner)
    current_user_is_admin = @current_user.account_permission?(@current_account, :admin)
    current_user_is_owner = @current_user.account_permission?(@current_account, :owner)

    if current_user_is_owner
      return true
    else
      # admins can't edit owners
      return (current_user_is_admin and not user_is_owner)
    end
  end
end