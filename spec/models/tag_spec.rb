require 'rails_helper'

RSpec.describe Tag, type: :model do
  it "is valid with a name" do
    tag = Tag.new(name: "Important")
    expect(tag).to be_valid
  end

  it "can be assigned to notes" do
    tag = Tag.create!(name: "Work")
    note = Note.create!(title: "Tagged", body: "With tags")
    note.tags << tag
    expect(note.tags.first.name).to eq("Work")
  end
end
