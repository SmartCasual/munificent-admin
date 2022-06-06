module Munificent
  module Admin
    class DonatorsController < ApplicationController
      load_and_authorize_resource class: "Munificent::Donator"

      def index; end
    end
  end
end
