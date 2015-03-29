require 'spec_helper'
require 'posts/repository'

RSpec.describe LightBlog::Posts::Repository do
  let(:content) do
"---
title: this is the title
subtitle: this is the subtitle
author: felipe sere
published: september 23, 2014
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
end

class FakeFilesytem
  def initialize
    @files = {}
  end

  def add_file(name, content)
    @files[name] = content
  end

  def all
    @files.values
  end
end
