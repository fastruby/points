require 'rails_helper'

RSpec.describe Project, type: :model do

it { should validate_presence_of(:title) }

end
