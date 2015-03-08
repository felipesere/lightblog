require 'spec_helper'
require 'routes'
require 'posts'

RSpec.describe 'single post', :type => :feature do
  before do
    clear
    create_post
  end

  it 'shows the title and subtitle' do
    visit '/ripples-in-abstraction'
    expect(page.find("#title")).to have_text 'Ripples in Abstraction'
    expect(page.find("#subtitle")).to have_text 'When things go gently wrong'
  end

  describe 'navigation to a post' do
    before do
      visit '/'
      page.click_link('Ripples in Abstraction')
    end

    it 'can be reached via a ling' do
      expect(page).to have_title 'Ripples in Abstraction'
    end
  end


  def create_post(params={})
    LightBlog::Posts.create(title: 'Ripples in Abstraction',
                   subtitle: 'When things go gently wrong',
                   author: 'Felipe Sere',
                   date: 'October 23, 2014',
                   slug: 'ripples-in-abstraction');
  end

  def clear
    LightBlog::Posts.clear
  end
end
