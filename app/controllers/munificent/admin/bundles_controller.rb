module Munificent
  module Admin
    class BundlesController < ApplicationController
      load_and_authorize_resource class: "Munificent::Bundle"
      before_action :prevent_edit, only: [:edit]

      helper StateMachineHelper

      def index; end
      def show; end

      def new
        @bundle.bundle_tiers.build
      end

      def edit
        @bundle.bundle_tiers.build(
          price_currency: @bundle.fundraiser.main_currency,
        )
      end

      def create
        if @bundle.save
          flash[:notice] = "Bundle created"
          redirect_to edit_bundle_path(@bundle)
        else
          flash[:alert] = @bundle.errors.full_messages.join(", ")
          redirect_to new_bundle_path
        end
      end

      def update
        @bundle.assign_attributes(bundle_params)
        @bundle.bundle_tiers = @bundle.bundle_tiers.compact_blank

        if @bundle.save
          flash[:notice] = "Bundle saved"
        else
          flash[:alert] = @bundle.errors.full_messages.join(", ")
        end

        redirect_to edit_bundle_path(@bundle)
      end

      def destroy
        @bundle.destroy
        redirect_to bundles_path
      end

      StateMachineHelper.define_actions(self, Bundle)

    private

      def bundle_params
        params.require(:bundle).permit(
          :fundraiser_id,
          :name,
          bundle_tiers_attributes: [
            :_destroy,
            :ends_at,
            :human_price,
            :id,
            :name,
            :price_currency,
            :starts_at,
            { game_ids: [] },
          ],
        )
      end

      def prevent_edit
        redirect_to bundle_path(@bundle), alert: "Live bundles cannot be edited" if @bundle.live?
      end

      def resource
        @bundle
      end
      helper_method :resource

      def presenter
        @presenter ||= Munificent::Admin::ApplicationPresenter.present(@bundle)
      end
      helper_method :presenter
    end
  end
end
