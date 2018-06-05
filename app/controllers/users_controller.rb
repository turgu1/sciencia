class UsersController < ApplicationController
  load_and_authorize_resource except: [:change_password_for, :do_change_password_for, :index, :show]

  def change_password_for
    @user = User.find(params[:id])
    authorize! :update, @user

    respond_to do |format|
      format.js
    end
  end

  def do_change_password_for
    pars = change_password_params
    @user = User.find(params[:id])
    authorize! :update, @user

    respond_to do |format|
      if pars[:password] == pars[:password_confirmation]
        if @user.update!(password: pars[:password], password_confirmation: pars[:password_confirmation])
          format.js { redirect_to users_path, notice: "Password for user [#{@user.username}] was successfully updated." }
        else
          format.js  { render action: "change_password_for" }
        end
      else
        flash[:error] = "The two passwords differ. Please retry."
        format.js  { render action: "change_password_for"  }
      end
    end
  end

  # GET /users
  # GET /users.json
  def index
    authorize! :manage, User
    @users = User.all.order(:username)

    respond_to do |format|
      format.html
      format.js   # _index.js.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js # edit.js.erb
    end
  end


  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(filter_params(user_params))
        format.html { redirect_to users_path, notice: "User [#{@user.username}] was successfully updated." }
        format.json { head :no_content }
      else
        format.html  { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    the_name = @user.username
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User [#{the_name}] was successfully deleted." }
      format.js { redirect_to users_path, notice: "User [#{the_name}] was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

    def user_params
      params.require(:user).permit(
          :username, :email, :password, :remember_me, {roles: []})
    end

    def change_password_params
      params.require(:user).permit(
          :password, :password_confirmation, :reset_password_token)
    end

    def filter_params(pars)
      pars[:roles] = pars[:roles].select { |i| !i.blank? } if pars[:roles]
      puts pars.inspect
      pars
    end
end
