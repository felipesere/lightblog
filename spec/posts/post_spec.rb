require 'spec_helper'
require 'posts/post'

RSpec.describe LightBlog::Posts::Post do
  let(:raw_post) do
"---
title: this is the title
author: felipe sere
date: 2015-03-23
slug: some-slug
---
I am not a fan of homoiconism

*what* up
"
  end

  describe "basic properties" do
    let(:post) do
      LightBlog::Posts::Post.from_raw(raw_post)
    end

    it "has a title" do
      expect(post.title).to eq "this is the title"
    end

    it "has an author" do
      expect(post.author).to eq "felipe sere"
    end

    it "has a slug" do
      expect(post.slug).to eq "some-slug"
    end

    it "has a date" do
      expect(post.date).to eq "March 23, 2015"
    end
  end

  it "generates a slug from the title" do
    post = LightBlog::Posts::Post.from_raw("---\ntitle: some title\n---")
    expect(post.slug).to eq "some-title"
  end
end
