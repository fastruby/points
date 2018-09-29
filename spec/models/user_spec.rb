require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.create(:user) }
end
