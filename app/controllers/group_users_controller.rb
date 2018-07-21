class GroupUsersController < ApplicationController
  # POST /groups/:group_id/group_users
  def create
    @group = Group.find(params[:group_id])
    @group_users = @group.group_users.create(group_users_params)

    redirect_to group_path(@group)
  end

  private
  def group_users_params
      params.require(:group_user).permit(:user_id)
  end
end
