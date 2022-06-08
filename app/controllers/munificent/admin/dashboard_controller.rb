module Munificent
  module Admin
    class DashboardController < ApplicationController
      def index
        authorize! :read, :self
      end
    end
  end
end
