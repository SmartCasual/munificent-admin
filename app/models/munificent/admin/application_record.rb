module Munificent
  module Admin
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
