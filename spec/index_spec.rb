require 'spec_helper'
require 'routes'

RSpec.describe "index", :type => :feature do
  it 'matches on some CSS' do
    visit '/'
    expect(page).to have_css '#viewport .post'
  end
end
