module EstimatesHelper
  def calculate_estimate_path
    [@project, @story, @estimate]
  end
end
