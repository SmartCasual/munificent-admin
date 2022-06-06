module Munificent
  module Admin
    class FundraisersController < ApplicationController
      load_and_authorize_resource class: "Munificent::Fundraiser"

      helper StateMachineHelper

      def index; end
      def show; end
      def new; end
      def edit; end

      def create
        if @fundraiser.save
          flash[:notice] = "Fundraiser created"
          redirect_to edit_fundraiser_path(@fundraiser)
        else
          flash[:alert] = @fundraiser.errors.full_messages.join(", ")
          redirect_to new_fundraiser_path
        end
      end

      def update
        @fundraiser.assign_attributes(fundraiser_params)
        @fundraiser.fundraiser_tiers = @fundraiser.fundraiser_tiers.compact_blank

        if @fundraiser.save
          flash[:notice] = "Fundraiser saved"
        else
          flash[:alert] = @fundraiser.errors.full_messages.join(", ")
        end

        redirect_to edit_fundraiser_path(@fundraiser)
      end

      def destroy
        @fundraiser.destroy
        redirect_to fundraisers_path
      end

      StateMachineHelper.define_actions(self, Fundraiser)

    private

      def fundraiser_params
        params.require(:fundraiser).permit(
          :description,
          :ends_at,
          :main_currency,
          :name,
          :overpayment_mode,
          :short_url,
          :starts_at,
          :state,
        )
      end

      def resource
        @fundraiser
      end
      helper_method :resource

      def presenter
        @presenter ||= Munificent::Admin::ApplicationPresenter.present(@fundraiser)
      end
      helper_method :presenter
    end
  end
end
