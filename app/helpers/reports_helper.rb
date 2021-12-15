module ReportsHelper
  def best_estimate_for_story(story)
    if story.estimates.length < 2
      "Not enough estimates"
    else
      story.best_estimate_average
    end
  end

  def worst_estimate_for_story(story)
    if story.estimates.length < 2
      "Not enough estimates"
    else
      story.worst_estimate_average
    end
  end

  def user_estimate(story, user, estimate_type)
    estimate = story.estimate_for(user)

    return "-" if estimate.nil?

    estimate_type == "best" ? estimate.best_case_points : estimate.worst_case_points
  end
end
