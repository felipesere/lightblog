require 'spec_helper'
require 'routes'
require 'posts'

RSpec.describe 'single post', :type => :feature do
  before do
    LightBlog::Posts.create(title: 'Ripples in Abstraction',
                   subtitle: 'When things go gently wrong',
                   author: 'Felipe Sere',
                   date: 'October 23, 2014',
                   slug: 'ripples-in-abstraction');
  end

  describe 'navigation to a post' do
    it 'can be reached via a ling' do
      visit '/'
      page.click_link('Ripples in Abstraction')
      expect(page).to have_title 'Ripples in Abstraction'
    end
  end
end
