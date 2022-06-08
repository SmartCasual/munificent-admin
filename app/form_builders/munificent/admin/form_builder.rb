module Munificent
  module Admin
    class FormBuilder < ActionView::Helpers::FormBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Context

      TEXT_FIELDS = %i[
        email_field
        number_field
        password_field
        text_area
        text_field
      ].freeze

      UNFLOATABLE_TYPES = %i[
        select
      ].freeze

      def field(type, name, label: name.to_s.humanize, **opts)
        field_tag = case type
        when *TEXT_FIELDS
          public_send(type, name, class: "form-control", placeholder: (label unless table_mode?))
        when :select
          select(name, opts[:source], select_field_opts(opts), select_html_opts(opts))
        else
          send(type, name, class: "form-control")
        end

        wrap(
          label(name, label, class: "form-label"),
          field_tag,
          field_name: name,
          float: UNFLOATABLE_TYPES.exclude?(type),
        )
      end

      def check_box(name, label: name.to_s.humanize, **opts)
        check_block = tag.div(class: "form-check") {
          super(name, class: "form-check-input", **check_box_opts(opts)) +
            label(name, label, class: "form-check-label")
        }

        wrap(check_block, field_name: name)
      end

      def table(css_class: nil, &block)
        @table_mode = true
        contents = @template.capture(&block)
        @table_mode = false

        css_class = (%w[table table-bordered] + Array(css_class)).compact.join(" ")
        tag.table(contents, class: css_class)
      end

      def money(name, default_currency: nil)
        field(:select, "#{name}_currency",
          label: "Currency",
          source: Munificent::Currency.present_all,
          selected: (object.public_send("#{name}_currency").presence || default_currency),
        ) + field(:text_field, "human_#{name}", label: name.to_s.humanize)
      end

    private

      def wrap(*args, field_name: nil, float: true)
        row_class = ["field-#{field_name}"]

        args.reverse! if float

        if table_mode?
          tag.tr(class: row_class.compact.join(" ")) do
            args.compact.map { |arg| tag.td(arg) }.reverse.reduce(:+)
          end
        else
          row_class << "mb-3"
          row_class += %w[form-floating mb-3] if float

          tag.div(class: row_class.compact.join(" ")) do
            args.compact.reduce(:+)
          end
        end
      end

      def table_mode?
        !!@table_mode
      end

      def select_field_opts(opts)
        { include_blank: opts[:optional] }.tap do |field_opts|
          field_opts[:selected] = opts[:selected] if opts[:selected]
        end
      end

      def select_html_opts(opts)
        { class: "form-select" }.tap do |html_opts|
          if opts[:multiple]
            html_opts.merge!(
              multiple: true,
              aria: { label: "multiple select" },
            )
          end
        end
      end

      def check_box_opts(opts)
        {}.tap do |field_opts|
          field_opts[:checked] = opts[:checked] unless opts[:checked].nil?
        end
      end
    end
  end
end
