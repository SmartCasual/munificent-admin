RSpec.describe Munificent::Admin::ResourceController do
  let(:controller) do
    r = resource_class # Avoid shadowing internal class methods

    Class.new(described_class) {
      self.resource_class = r
    }.tap { |c|
      c.include CanCan::ControllerAdditions
      c.class_eval(&block)
      stub_const("Munificent::Admin::TestsController", c)
    }
  end

  let(:resource_class) { "Munificent::Charity" }
  let(:block) { proc {} }

  describe ".resource_class" do
    context "when not provided" do
      let(:resource_class) { nil }

      it "raises an error" do
        expect {
          controller.resource_class
        }.to raise_error(Munificent::Admin::ResourceController::MissingResourceClassError)
      end
    end

    context "when provided" do
      let(:resource_class) { "Munificent::Bundle" }

      it "returns the resource class" do
        expect(controller.resource_class).to eq("Munificent::Bundle")
      end
    end
  end

  describe ".actions(only: DEFAULT_ACTIONS, except: [])" do
    let(:block) { proc { actions } }

    it "has the normal CRUD actions" do
      expect(controller.action_methods).to eq(%w[index show new create edit update destroy].to_set)
    end

    context "when only: is specified" do
      let(:block) { proc { actions(only: %i[index show]) } }

      it "has the specified actions" do
        expect(controller.action_methods).to eq(%w[index show].to_set)
      end
    end

    context "when unsupported actions are specified in only:" do
      let(:block) { proc { actions(only: %i[orange blue]) } }

      it "raises an error" do
        expect {
          controller.action_methods
        }.to raise_error(ArgumentError)
      end
    end

    context "when except: is specified" do
      let(:block) { proc { actions(except: %i[index show]) } }

      it "has the remaining actions" do
        expect(controller.action_methods).to eq(%w[new create edit update destroy].to_set)
      end
    end

    context "when unsupported actions are specified in except:" do
      let(:block) { proc { actions(except: %i[orange blue]) } }

      it "raises an error" do
        expect {
          controller.action_methods
        }.to raise_error(ArgumentError)
      end
    end

    context "when the resource class has a state machine" do
      let(:resource_class) { "Munificent::Fundraiser" }

      it "defines actions for each state event" do
        expect(controller.action_methods).to include(*%w[activate deactivate reactivate archive])
      end
    end

    context "for renderable actions" do
      let(:resource_class) { "Munificent::Charity" }
      let(:controller_instance) { controller.new }

      before do
        create_list(:charity, 2)
      end

      it "yields after loading the resource set for `index`" do
        r = nil
        controller_instance.index do
          run_callbacks(:before)
          p @charities
          r = @charities
        end

        expect(r).to eq(Munificent::Charity.all)
      end

      %w[show new edit].each do |action|
        it "yields after loading the individual resource for `#{action}`" do
          charity = Munificent::Charity.first
          controller_instance.params = { id: charity.id }

          r = nil
          controller_instance.public_send(action) do
            r = @charity
          end

          expect(r).to eq(charity)
        end
      end
    end
  end
end
