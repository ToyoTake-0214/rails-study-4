class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      @user.generate_reset_password_token!
      UserMailer.reset_password_email(@user).deliver_now
    end
    redirect_to login_path, success: t('.success')
  end

  def edit
    @token = params[:id]
    set_user_by_reset_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    set_user_by_reset_token(@token)
    return not_authenticated if @user.blank?

    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_reset_token(token)
    user = User.find_by(reset_password_token: token)
    @user = user if user.present? && user.reset_password_token_expires_at&.future?
  end
end
