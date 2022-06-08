module Munificent
  module Admin
    RSpec.describe ApplicationPresenter do
      describe ".present(record)" do
        subject(:presented_record) { described_class.present(record) }

        let(:record) { build(:bundle) }

        it "returns a presenter for the specific record type" do
          expect(presented_record).to be_a(Munificent::BundlePresenter)
        end

        it "returns a presenter with the correct record" do
          expect(presented_record.record).to eq(record)
        end

        context "when the record is not a known type" do
          let(:record) { Object.new }

          it "raises an error" do
            expect { presented_record }.to raise_error(
              ArgumentError,
              "No presenter available for record type `#{record.class.name}`",
            )
          end
        end
      end
    end
  end
end
