require 'spec_helper'
require 'posts/repository'

RSpec.describe LightBlog::Posts::Repository do
  let(:content) do
"---
title: this is the title
author: felipe sere
date: 2014-9-23
slug: some-slug
---

# i am not a fan of homoiconism
"
  end

  let(:filesystem) do
    filesystem = FakeFilesytem.new
    filesystem.add_file('first_post.md', content)
    filesystem
  end

  let(:repo) do
    described_class.new(filesystem)
  end

  it "can read a post from a filesystem" do
    expect(repo.all.count).to eq 1
    expect(repo.all.first).to be_a LightBlog::Posts::Post
  end

  it "can find a post by slug" do
    expect(repo.find_by_slug("some-slug")).to be_a LightBlog::Posts::Post
  end

  describe "orders posts" do
    let(:post1) {create_post("first", "2011-9-23")}
    let(:post2) {create_post("second","2012-3-11")}
    let(:post3) {create_post("third", "2013-5-10")}
    let(:post4) {create_post("fourth","2014-8-12")}
    let(:post5) {create_post("fifth", "2015-9-13")}

    let(:repo) do
      fs = FakeFilesytem.new
      fs.add_file("fifth", post5)
      fs.add_file("second", post2)
      fs.add_file("fourth", post4)
      fs.add_file("first", post1)
      fs.add_file("third", post3)
      described_class.new(fs)
    end

    it "returns posts sorted by date" do
      expect(repo.all.map{|post| post.title}).to eq ["fifth", "fourth", "third", "second", "first"]
    end

    it "returns the next newer post" do
      middle_post = repo.find_by_slug("third")
      expect(repo.newer(middle_post).title).to eq "fourth"
    end

    it "newest post has no newer" do
      fifth = repo.find_by_slug("fifth")
      expect(repo.newer(fifth)).to be_nil
    end

    it "returns the next older post" do
      middle_post = repo.find_by_slug("third")
      expect(repo.older(middle_post).title).to eq "second"
    end

    it "oldest post has no older" do
      first = repo.find_by_slug("first")
      expect(repo.older(first)).to be_nil
    end
  end
end

def create_post(title, date)
"---
title: #{title}
date: #{date}
---

# Hi there
"
end

class FakeFilesytem
  def initialize(files = [])
    @files = {}
  end

  def add_file(name, content)
    @files[name] = content
  end

  def all
    @files.values
  end
end
