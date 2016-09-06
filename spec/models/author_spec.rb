RSpec.describe Author, type: :model do
  it { should validate_presence_of(:given_name) }
  it { should validate_presence_of(:family_name) }

  it "has a valid factory" do
    expect(build(:author)).to be_valid
  end
end