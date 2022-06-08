module Munificent
  module Admin
    class DonationsController < ApplicationController
      load_and_authorize_resource class: "Munificent::Donation"

      def index; end
    end
  end
end
