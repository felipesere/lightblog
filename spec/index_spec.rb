require 'spec_helper'
require 'routes'

RSpec.describe "index", :type => :feature do
  before do
    visit '/'
  end

  it 'has a title' do
    expect(page).to have_title 'Code Paradoxon'
    expect(page.find("#title").text).to eq 'Code Paradoxon'
    expect(page.find("#subtitle").text).to eq 'Musings on Code'
  end

  describe 'posts' do
    it 'has a container for posts' do
      expect(page).to have_css('.posts')
    end
  end

  describe 'single post' do
    let(:post) do
      page.find('.posts').all('.post').first
    end

    it 'has a title link' do
      expect(post.find_link('Ripples in Abstraction')).to have_css('.post-title')
    end

    it 'has a subtitle' do
      expect(post.find('.post-subtitle').text).to eq 'When things go gently wrong'
    end

    it 'it has a author link' do
      expect(post).to have_link("Felipe Sere")
    end

    it 'has a metadata tagline' do
      expect(post.find('.metadata').text).to eq "Posted by Felipe Sere on October 23, 2014"
    end
  end

end
