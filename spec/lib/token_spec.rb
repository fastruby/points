require "token"
require "rails_helper"

RSpec.describe Token, type: :lib do
  describe ".issue" do
    context "without a payload" do
      it { expect { Token.issue }.to raise_error(ArgumentError) }
    end

    context "with a payload" do
      it "returns a MD5 token" do
        payload = "asdf"
        expected_result = Digest::MD5.hexdigest(payload)

        token = Token.issue(payload)

        expect(token).to eq(expected_result)
      end
    end

    context "with an algorithm" do
      it "returns a specific token" do
        payload = "asdf"
        expected_result = Digest::SHA1.hexdigest(payload)

        token = Token.issue(payload, "SHA1")

        expect(token).to eq(expected_result)
      end
    end
  end
end
