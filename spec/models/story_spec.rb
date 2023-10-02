require "rails_helper"

RSpec.describe Story, type: :model do
  subject { FactoryBot.create(:story, real_score: real_score) }
  let(:real_score) { 1 }

  it { should validate_presence_of(:title) }

  it { should belong_to(:project) }

  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }

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
      let(:estimate_1) { Estimate.new(best_case_points: 10, worst_case_points: 20, user: user) }
      let(:estimate_2) { Estimate.new(best_case_points: 100, worst_case_points: 200, user: user2) }

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

  describe "#percentage_off_estimate" do
    context "when average is 0" do
      let(:estimate_average) { 0 }

      it "returns 0" do
        expect(subject.percentage_off_estimate(estimate_average)).to eq(0)
      end
    end

    context "when average is > 0" do
      let(:average) { 1 }

      context "when real_score is the same" do
        it "returns 0 because estimate was on point" do
          expect(subject.percentage_off_estimate(average)).to eq(0)
        end
      end

      context "when real_score is twice the average" do
        let(:real_score) { average * 2 }

        it "returns 100% off" do
          expect(subject.percentage_off_estimate(average)).to eq(100)
        end
      end

      context "when real_score is nil (by default it's nil)" do
        let(:real_score) { nil }

        it "returns 0" do
          expect(subject.percentage_off_estimate(average)).to eq(0)
        end
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
      let(:estimate_2) { Estimate.new(best_case_points: 100, worst_case_points: 200, user: user2) }

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
end
