class RelationshipsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # respond_to along with remote: true on forms enables AJAX to run without reloading page
    respond_to do |format|
      format.js
      format.html {redirect_to @user}
      end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed 
    current_user.unfollow(@user)
    # respond_to along with remote: true on forms enables AJAX to run without reloading page
    respond_to do |format|
      format.js
      format.html {redirect_to @user}
    end 
  end

end
