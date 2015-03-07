require 'spec_helper'
require 'index/show'

RSpec.describe LightBlog::Index::Show, :type => :feature do
  it 'matches on some CSS' do
    visit '/'
    expect(page).to have_css '#viewport .post'
  end
end
