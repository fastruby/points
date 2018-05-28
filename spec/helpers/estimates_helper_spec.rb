require "rails_helper"

describe EstimatesHelper, type: :helper do
  describe "#fib_numbers" do
    it "max option should be [21, 21]" do
      max_fib_number = helper.fib_numbers.max_by { |f| f[0] }
      expect(max_fib_number).to eq([21, 21])
    end
  end
end
