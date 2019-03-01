require 'rails_helper'

RSpec.describe Story, type: :model do
  subject { FactoryBot.create(:story) }

  it { should validate_presence_of(:title) }

  it { should belong_to(:project) }

  let!(:user) { FactoryBot.create(:user) }

  describe "#best_estimate_average" do
    context "there are no estimates" do
      it "returns 0" do
        expect(subject.best_estimate_average).to eq(0)
      end
    end
    context "there is one estimate" do
      let(:estimate_1) { Estimate.new(best_case_points: 1, worst_case_points: 2, user: user) }
      subject {
        result = FactoryBot.create(:story)
        result.estimates = [estimate_1]
        result
      }

      it "returns 0" do
        expect(subject.best_estimate_average).to eq(0)
      end
    end
    context "there are two or more estimates" do
      let(:estimate_1) { Estimate.new(best_case_points: 10, worst_case_points: 2, user: user) }
      let(:estimate_2) { Estimate.new(best_case_points: 100, worst_case_points: 200, user: user) }

      subject {
        result = FactoryBot.create(:story)
        result.estimates = [estimate_1, estimate_2]
        result
      }

      it "returns the average" do
        expect(subject.best_estimate_average).to eq(55)
      end
    end
  end

  describe "#worst_estimate_average" do
    context "there are no estimates" do
      it "returns 0" do
        expect(subject.worst_estimate_average).to eq(0)
      end
    end
    context "there is one estimate" do
      let(:estimate_1) { Estimate.new(best_case_points: 1, worst_case_points: 2, user: user) }
      subject {
        result = FactoryBot.create(:story)
        result.estimates = [estimate_1]
        result
      }

      it "returns 0" do
        expect(subject.worst_estimate_average).to eq(0)
      end
    end
    context "there are two or more estimates" do
      let(:estimate_1) { Estimate.new(best_case_points: 10, worst_case_points: 20, user: user) }
      let(:estimate_2) { Estimate.new(best_case_points: 100, worst_case_points: 200, user: user) }

      subject {
        result = FactoryBot.create(:story)
        result.estimates = [estimate_1, estimate_2]
        result
      }

      it "returns the average" do
        expect(subject.worst_estimate_average).to eq(110)
      end
    end
  end

  context "there are two estimates" do
    let(:estimate_1) { Estimate.new(best_case_points: 10, worst_case_points: 2, user: user) }
    let(:estimate_2) { Estimate.new(best_case_points: 100, worst_case_points: 200, user: user) }

    describe "#best_estimate_sum" do
      subject {
        result = FactoryBot.create(:story)
        result.estimates = [estimate_1, estimate_2]
        result
      }

      it "returns the sum" do
        expect(subject.best_estimate_sum).to eq(110)
      end
    end

    describe "#worst_estimate_sum" do
      subject {
        result = FactoryBot.create(:story)
        result.estimates = [estimate_1, estimate_2]
        result
      }

      it "returns the sum" do
        expect(subject.worst_estimate_sum).to eq(202)
      end
    end
  end
end
