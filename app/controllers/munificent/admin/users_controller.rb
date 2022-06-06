module Munificent
  module Admin
    class UsersController < ApplicationController
      load_and_authorize_resource class: "Munificent::Admin::User"

      def index
        authorize!(:read, :user_accounts)
      end

      def show; end
      def new; end
      def edit; end

      def create
        if @user.save
          flash[:notice] = "User created"
          redirect_to edit_user_path(@user)
        else
          flash[:alert] = @user.errors.full_messages.join(", ")
          redirect_to new_user_path
        end
      end

      def update
        model = :user
        if params[model][:password].blank?
          %w[password password_confirmation].each { |p| params[model].delete(p) }
        end

        @user.assign_attributes(user_params)

        if @user.save
          flash[:notice] = "User saved"
        else
          flash[:alert] = @user.errors.full_messages.join(", ")
        end

        redirect_to edit_user_path(@user)
      end

      def destroy
        @user.destroy
        redirect_to users_path
      end

    private

      def user_params
        params.require(:user).permit(
          *%i[
            active
            approved
            confirmed
            data_entry
            email_address
            full_access
            manages_users
            name
            password
            password_confirmation
            support
          ],
        )
      end

      def resource
        @user
      end
      helper_method :resource

      def presenter
        @presenter ||= Munificent::Admin::ApplicationPresenter.present(@user)
      end
      helper_method :presenter
    end
  end
end
