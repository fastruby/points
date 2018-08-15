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

end
