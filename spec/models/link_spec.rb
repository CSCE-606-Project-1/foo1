require 'rails_helper'

RSpec.describe Link, type: :model do
  it "belongs to a note" do
    note = Note.create!(title: "Link Note", body: "with link")
    link = note.links.create!(url: "https://example.com")
    expect(link.note).to eq(note)
  end

  it "is invalid without a URL" do
    link = Link.new
    expect(link).not_to be_valid
  end
end
