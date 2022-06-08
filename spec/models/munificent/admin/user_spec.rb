RSpec.describe Munificent::Admin::User, type: :model do
  describe "#permissions" do
    subject(:permissions) { described_class.new(set_permissions).permissions }

    context "when the admin has no permissions" do
      let(:set_permissions) { {} }

      it { is_expected.to eq([]) }
    end

    context "when the admin has individual permissions" do
      let(:set_permissions) do
        {
          data_entry: true,
          manages_users: true,
          support: true,
          full_access: false,
        }
      end

      it { is_expected.to eq(["data entry", "manages users", "support"]) }
    end

    context "when the admin has full access in addition to any other permissions" do
      let(:set_permissions) do
        {
          data_entry: true,
          manages_users: true,
          support: false,
          full_access: true,
        }
      end

      it { is_expected.to eq(["full access"]) }
    end
  end

  # See comment in user model
  xdescribe "states" do
    subject(:states) { described_class.new(set_states).states }

    context "when the user has no states set" do
      let(:set_states) { {} }

      it { is_expected.to eq([]) }
    end

    context "when the user has some states set" do
      let(:set_states) do
        {
          active: true,
          confirmed: true,
        }
      end

      it { is_expected.to match_array(%w[active confirmed]) }
    end

    context "when the user has all the states set" do
      let(:set_states) do
        {
          active: true,
          approved: true,
          confirmed: true,
        }
      end

      it { is_expected.to match_array(%w[active approved confirmed]) }
    end
  end
end
