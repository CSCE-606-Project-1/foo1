require 'rails_helper'

# Define a named class for testing Formatable
class DummyFormatable
  include Formatable
  def to_s
    "TestObj"
  end
end

RSpec.describe Formatable, type: :model do
  let(:instance) { DummyFormatable.new }

  it "returns text when format is :text" do
    expect(instance.to_format(:text)).to eq("TestObj")
  end

  it "returns html span when format is :html" do
    html = instance.to_format(:html)
    expect(html).to include("<span class=\"dummyformatable\">TestObj</span>")
  end

  it "raises error on unsupported format" do
    expect { instance.to_format(:json) }.to raise_error(ArgumentError)
  end
end
