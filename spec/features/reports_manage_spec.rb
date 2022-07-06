require "rails_helper"

RSpec.describe "managing reports", js: true do
  let!(:user) { FactoryBot.create(:user, :admin, name: "John") }
  let!(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project, real_score: 4) }

  before do
    login_as(user, scope: :user)
  end

  it "shows message for no projects" do
    project.destroy
    visit reports_index_path
    expect(page).to have_content "No Projects"
  end

  context "with no estimates" do
    it "shows no estimates" do
      visit project_report_path(project.id)
      expect(page).to have_content "Not enough estimates"
    end
  end

  context "with one estimate" do
    let!(:estimate) { FactoryBot.create(:estimate, story: story, user: user) }

    it "allows me see a report with a project title, list of stories and estimates" do
      visit project_report_path(project.id)

      expect(page).to have_content project.title
      expect(page).to have_content story.title
      expect(page).to have_content "#{user.name}'s Best Estimate"
      expect(page).to have_content "#{user.name}'s Worst Estimate"
    end

    it "does not calculate averages" do
      visit project_report_path(project.id)
      expect(page).to have_content "Not enough estimates"
    end
  end

  context "with more than one estimate" do
    let!(:user_2) { FactoryBot.create(:user, name: "Sarah") }
    let!(:estimate) do
      FactoryBot.create(:estimate, story: story, user: user, best_case_points: 1, worst_case_points: 4)
    end
    let!(:estimate_2) do
      FactoryBot.create(:estimate, story: story, user: user_2, best_case_points: 3, worst_case_points: 8)
    end
    let(:best_average) { "2.0" }
    let(:worst_average) { "6.0" }
    let(:percentage_off_best_average) { "100.00%" }
    let(:percentage_off_worst_average) { "33.33%" }
    let!(:best_estimate_total) { 1 }
    let!(:worst_estimate_total) { 3 }
    let!(:best_estimate_sum_per_user) { 1 }
    let!(:worst_estimate_sum_per_user) { 3 }

    it "calculates averages and percentage off estimate" do
      visit project_report_path(project.id)

      expect(page).to have_content(best_average)
      expect(page).to have_content(worst_average)
      expect(page).to have_content(percentage_off_best_average)
      expect(page).to have_content(percentage_off_worst_average)
    end
    let(:best_estimate_total) { "2" }
    let(:worst_estimate_total) { "6" }
    let(:real_score_total) { "4" }
    let(:best_estimate_sum_per_user) { "1" }
    let(:best_estimate_sum_per_user_2) { "3" }
    let(:worst_estimate_sum_per_user) { "4" }
    let(:worst_estimate_sum_per_user_2) { "6" }
    let(:percentage_off_estimate_total_best) { "100.00%" }
    let(:percentage_off_estimate_total_worst) { "33.33%" }

    it "calculates totals in the last row" do
      visit project_report_path(project.id)

      expect(page).to have_content(best_estimate_total)
      expect(page).to have_content(worst_estimate_total)
      expect(page).to have_content(real_score_total)
      expect(page).to have_content(best_estimate_sum_per_user)
      expect(page).to have_content(best_estimate_sum_per_user_2)
      expect(page).to have_content(worst_estimate_sum_per_user)
      expect(page).to have_content(worst_estimate_sum_per_user_2)
      expect(page).to have_content(percentage_off_estimate_total_best)
      expect(page).to have_content(percentage_off_estimate_total_worst)
    end

    # there's a bug that allows estimators to have more than 1 estimate for a given story
    # even after that bug gets fixed, we have to be sure we handle old data correctly
    context "by the same user" do
      let!(:another_estimate) do
        x = FactoryBot.build(:estimate, story: story, user: user, best_case_points: 8, worst_case_points: 13, created_at: 2.minutes.from_now)
        x.save(validate: false)
      end

      it "uses the first estimation" do
        visit project_report_path(project.id)

        expect(story.estimates.where(user: user).count).to be 2

        within "tbody tr:first-child" do
          expect(find("td:nth-child(2)")).to have_text "1"
          expect(find("td:nth-child(3)")).to have_text "4"
          expect(find("td:nth-child(7)")).to have_text "2"
          expect(find("td:nth-child(8)")).to have_text "6"
        end

        within "tfoot tr:first-child" do
          expect(find("td:nth-child(2)")).to have_text "1"
          expect(find("td:nth-child(3)")).to have_text "4"
          expect(find("td:nth-child(7)")).to have_text "2"
          expect(find("td:nth-child(8)")).to have_text "6"
        end
      end
    end
  end
end
