module Munificent
  module Admin
    class BundleTiersController < ApplicationController
      load_and_authorize_resource class: "Munificent::BundleTier"

      def destroy
        @bundle_tier.destroy
        redirect_to edit_bundle_path(@bundle_tier.bundle)
      end
    end
  end
end
