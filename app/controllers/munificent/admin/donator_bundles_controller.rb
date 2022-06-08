module Munificent
  module Admin
    class DonatorBundlesController < ApplicationController
      load_and_authorize_resource class: "Munificent::DonatorBundle"

      def index; end
    end
  end
end
