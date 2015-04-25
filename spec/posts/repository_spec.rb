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

  it "returns posts sorted by date" do
    post1 = create_post("first", "2014-9-23")
    post2 = create_post("second", "2015-10-11")
    fs = FakeFilesytem.new
    fs.add_file("first", post1)
    fs.add_file("second", post2)

    repo = described_class.new(fs)
    expect(repo.all.map{|post| post.title}).to eq ["second", "first"]
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
