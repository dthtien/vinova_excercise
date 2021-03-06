class PostsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def show
    @comment = Comment.new
    @comment.build_image
  end

  def new
    @post = Post.new
    @post.images.build
    respond_to do |format|
      format.html
      format.js
    end
  end


  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.js
      else
        format.html { render :new }
      end
    end
  end

  def edit
    authorize @post
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    authorize @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.js
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Post was successfully destroyed.' }
      format.js
    end
  end

  private
    def set_post
      @post = Post.includes(:comments).includes(:user).find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content, :user_id, images_attributes: [:image_upload])
    end
end
