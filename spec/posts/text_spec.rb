RSpec.describe LightBlog::Posts::Text do
  let(:raw_post) do
"
Some snippet with more stuff
<!-- more -->
I am not a fan of homoiconism
"
  end
  let(:text) { described_class.new(raw_post) }

  it "has content" do
    expect(text.content).to eq "<p>Some snippet with more stuff</p>\n\n<p>I am not a fan of homoiconism</p>"
  end

  it "has a capped snippet" do
    expect(text.snippet(3)).to eq "<p>Some snippet with...</p>"
  end

  it "has a capped snippet" do
    expect(text.snippet).to eq "<p>Some snippet with more stuff...</p>"
  end
end
