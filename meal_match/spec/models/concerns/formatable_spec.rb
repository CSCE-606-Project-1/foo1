require "rails_helper"

class FormatableSpecDummy
  include Formatable

  def initialize(text)
    @text = text
  end

  def to_s
    @text
  end
end

RSpec.describe Formatable do
  subject(:formatter) { FormatableSpecDummy.new("<Test>") }

  it "returns text format by delegating to #to_s" do
    expect(formatter.to_format(:text)).to eq("<Test>")
  end

  it "wraps the string in a span for HTML format and escapes content" do
    expect(formatter.to_format(:html)).to eq('<span class="formatablespecdummy">&lt;Test&gt;</span>')
  end

  it "raises an error for unsupported formats" do
    expect { formatter.to_format(:json) }.to raise_error(ArgumentError, /unsupported format/)
  end
end
