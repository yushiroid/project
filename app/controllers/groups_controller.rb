class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/:id
  def show
    @group = Group.find(params[:id])
  end

  # GET /posts/:id/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  def create
    @group = Group.new(post_params)
    if @group.save
      redirect_to @group
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH /posts/:id
  # PUT   /posts/:id
  def update
    @group = Group.find(params[:id])
    if @group.update(post_params)
      redirect_to @group
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def post_params
      params.require(:group).permit(:name, :text)
    end

end
