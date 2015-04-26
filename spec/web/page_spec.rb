require 'web/page'

RSpec.describe LightBlog::Web::Page do
  let(:page) { described_class.new(20, { "page" => 2, "size"=>5}) }

  it "links to the next page" do
    expect(page.next.url).to eq "/?page=3&size=5"
  end

  it "links to the previous page" do
    expect(page.previous.url).to eq "/?page=1&size=5"
  end

  it "it has a url" do
    expect(page.url).to eq "/?page=2&size=5"
  end

  it "has no previous at the beginning" do
    expect(first_page.previous).to be_nil
  end

  it "has no parameters for first page" do
    expect(first_page.url).to eq "/"
  end

  it "last page has no next" do
    expect(last_page.next).to be_nil
  end

  it "filters elements" do
    elements = ['a', 'b', 'c', 'd', 'e']
    page = described_class.new(elements.count, {"page" => 1, "size" => 2 })
    expect(page.filter(elements)).to eq ['c', 'd']
  end

  def first_page
    described_class.new(7, { "page" => 0, "size" => 3})
  end

  def last_page
    described_class.new(7, { "page" => 2, "size" => 3})
  end
end

