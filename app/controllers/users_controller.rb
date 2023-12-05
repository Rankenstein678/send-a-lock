require 'socket'

class UsersController < ApplicationController
  def index
    @users = User.where(verified: true).order(:name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.init(user_params)

    if @user.save
      UnverifiedUserCleanup.set(wait: 30.minutes).perform_later(@user)
      send_verification_email(@user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.confirmation_code == params[:code]
      @user.verified = true
      @user.save
    end
  end

  private

  def send_verification_email(user)
    url = "http://#{ENV['DOMAIN']}/users/#{user.id}/confirm/#{user.confirmation_code}"
    pid = fork { spawn("./mailing/verification_mail.py #{user.email} #{url}") }
    Process.detach(pid)
  end

  def user_params
    params.require(:user).permit(:email, :public_key)
  end

end
