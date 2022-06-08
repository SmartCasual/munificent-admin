module Munificent
  module Admin
    class ApplicationPresenter < ActionView::Base
      def self.delegate(array, to: :record)
        super(*array, to:)
      end

      def self.present(record)
        presenter_class_for(record).new(record)
      end

      def self.presenter_class_for(record)
        "#{record.class.name}Presenter".constantize
      rescue NameError
        raise ArgumentError, "No presenter available for record type `#{record.class.name}`"
      end

      attr_reader :record

      def initialize(record) # rubocop:disable Lint/MissingSuper
        @record = record
      end

      def name
        record
      end
    end
  end
end
