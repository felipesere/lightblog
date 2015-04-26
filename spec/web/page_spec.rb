require 'web/page'

RSpec.describe LightBlog::Web::Page do
  let(:elements) { ['a', 'b', 'c', 'd', 'e', 'f', 'g','h','i'] }
  let(:page) { described_class.new(elements, 2, 2) }

  it "links to the next page" do
    expect(page.next.url).to eq "/?page=3"
  end

  it "links to the previous page" do
    expect(page.previous.url).to eq "/?page=1"
  end

  it "it has a url" do
    expect(page.url).to eq "/?page=2"
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
    expect(page.filter).to eq ['e', 'f']
  end

  def first_page
    described_class.new(elements, 0, 3)
  end

  def last_page
    described_class.new(elements, 2, 3)
  end
end

