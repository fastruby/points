require "rails_helper"

RSpec.describe User, type: :model do
  subject { FactoryBot.create(:user) }

  describe "Class Methods" do
    describe ".from_omniauth" do
      let(:auth) do
        RecursiveOpenStruct.new(provider: "github",
          uid: "uuiidd11",
          info: {email: "testuser@email.com", name: "TestUser"})
      end

      it "creates a user" do
        expect {
          User.from_omniauth(auth)
        }.to change { User.count }
      end

      it "updates an existing user" do
        User.from_omniauth(auth)
        auth.info.name = "benjamin"
        User.from_omniauth(auth)
        expect(User.last.name).to eql "benjamin"
      end

      it "returns a user record" do
        expect(User.from_omniauth(auth)).to be_a User
      end
    end
  end
  describe "Instance Methods" do
    describe "#name" do
      it "returns the name a name exists" do
        expect(subject.name).to eql subject.name
      end

      it "returns the email if the name doesn't exist" do
        subject.name = nil
        expect(subject.name).to eql subject.email
      end
    end
  end
end
