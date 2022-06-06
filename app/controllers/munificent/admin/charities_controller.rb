module Munificent
  module Admin
    class CharitiesController < ApplicationController
      load_and_authorize_resource class: "Munificent::Charity"

      def index; end
      def show; end
      def new; end
      def edit; end

      def create
        if @charity.save
          flash[:notice] = "Charity created"
          redirect_to edit_charity_path(@charity)
        else
          flash[:alert] = @charity.errors.full_messages.join(", ")
          redirect_to new_charity_path
        end
      end

      def update
        @charity.assign_attributes(charity_params)
        @charity.charity_tiers = @charity.charity_tiers.compact_blank

        if @charity.save
          flash[:notice] = "Charity saved"
        else
          flash[:alert] = @charity.errors.full_messages.join(", ")
        end

        redirect_to edit_charity_path(@charity)
      end

      def destroy
        @charity.destroy
        redirect_to charities_path
      end

    private

      def charity_params
        params.require(:charity).permit(
          :name,
          :description,
          fundraiser_ids: [],
        )
      end

      def resource
        @charity
      end
      helper_method :resource

      def presenter
        @presenter ||= Munificent::Admin::ApplicationPresenter.present(@charity)
      end
      helper_method :presenter
    end
  end
end
