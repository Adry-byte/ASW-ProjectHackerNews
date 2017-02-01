module UsersHelper
  def getUser(id)
    @user = User.find(id)
    return  @user
  end
end
