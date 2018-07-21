class GroupsController < ApplicationController

  # GET /groups
  def index
    @group = Group.all
  end
  # GET /groups/new
  def new
    @group = Group.new
  end
end
