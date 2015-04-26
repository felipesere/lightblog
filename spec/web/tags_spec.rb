require 'spec_helper'
require 'web/tags'

RSpec.describe LightBlog::Web::Tags do

  let(:tags) { described_class.new }

  it "creates multiple css tags" do
    expect(tags.css('foo','bar')).to eq "<link rel=\"stylesheet\" href=\"/css/foo.css\">\n<link rel=\"stylesheet\" href=\"/css/bar.css\">"
  end

  it "creates multiple js tags" do
    expect(tags.js('foo','bar')).to eq "<script src=\"/js/foo.js\" type=\"text/javascript\"></script>\n<script src=\"/js/bar.js\" type=\"text/javascript\"></script>"
  end

  context "image tag" do
    it "has a src" do
      expect(tags.image('icons/foo.png')).to eq "<img src=\"/images/icons/foo.png\"/>"
    end

    it "can have a classes" do
      expect(tags.image('icons/foo.png', class: ['a','b'])).to eq "<img src=\"/images/icons/foo.png\" class=\"a b\"/>"
    end

    it "can have an alt tag" do
      expect(tags.image('icons/foo.png', alt: 'Home')).to eq "<img src=\"/images/icons/foo.png\" alt=\"Home\"/>"
    end
  end

  it "creates multiple image tags" do
    expect(tags.image(['icons/foo.png', 'icons/bar.png'], class: ['a','b'])).to eq "<img src=\"/images/icons/foo.png\" class=\"a b\"/>\n<img src=\"/images/icons/bar.png\" class=\"a b\"/>"
  end
end
