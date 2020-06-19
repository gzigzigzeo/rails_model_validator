RSpec.describe RailsModelValidator do
  let(:attributes) { {} }
  subject { TestModel.new(attributes) }

  context "invalid" do
    it { is_expected.to be_invalid }
  end

  context "valid" do
    let(:attributes) { { name: "Me", size: 25 } }

    it { is_expected.to be_valid }
  end
end
