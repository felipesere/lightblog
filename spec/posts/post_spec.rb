require 'spec_helper'
require 'posts/post'

RSpec.describe LightBlog::Posts::Post do
  let(:raw_post) do
"---
title: this is the title
subtitle: this is the subtitle
author: felipe sere
date: 2015-03-23
slug: some-slug
---

# i am not a fan of homoiconism
"
  end

  describe "basic properties" do
    let(:post) do
      LightBlog::Posts::Post.from_raw(raw_post)
    end

    it "has a title" do
      expect(post.title).to eq "this is the title"
    end

    it "has a subtitle" do
      expect(post.subtitle).to eq "this is the subtitle"
    end

    it "has an author" do
      expect(post.author).to eq "felipe sere"
    end
    
    it "has an author" do
      expect(post.author).to eq "felipe sere"
    end

    it "has a slug" do
      expect(post.slug).to eq "some-slug"
    end

    it "has a date" do
      expect(post.date).to eq Date.new(2015,3,23)
    end
  end

  describe "generated properties" do
    it "generates a slug from the title" do
      post = LightBlog::Posts::Post.from_raw("---\ntitle: Some Title\n---")
      expect(post.slug).to eq "some-title"
    end
  end
end
