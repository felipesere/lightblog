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
      expect(post.date).to eq "March 23, 2015"
    end

    it "has raw content" do
      expect(post.content).to eq "<p>I am not a fan of homoiconism</p>\n\n<p><em>what</em> up</p>\n"
    end

    it "has a baisc snippet" do
      expect(post.snippet(3)).to eq "<p>I am not…</p>"
    end
  end

  it "simple test" do
    content = File.read("./posts/first_post.md")
    post = LightBlog::Posts::Post.from_raw(content)
    expect(post.snippet).to eq "<p>This is some random text I am just making up…</p>"
  end

  describe "generated properties" do
    it "generates a slug from the title" do
      post = LightBlog::Posts::Post.from_raw("---\ntitle: some title\n---")
      expect(post.slug).to eq "some-title"
    end

    it "generates a short snippet" do
      content = "---\ntitle: some title\n---\nThis is the snippet<!-- more -->This is not it"

      post = LightBlog::Posts::Post.from_raw(content)
      expect(post.snippet(25)).to eq "<p>This is the snippet…</p>"
    end
  end
end
