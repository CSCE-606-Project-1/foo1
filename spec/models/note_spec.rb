# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  it 'is valid with a title and body' do
    note = Note.new(title: 'My Note', body: 'Some text')
    expect(note).to be_valid
  end

  it 'is invalid without a title' do
    note = Note.new(body: 'Missing title')
    expect(note).not_to be_valid
  end

  it 'can have many pdfs' do
    note = Note.create!(title: 'With PDFs', body: 'Testing')
    note.pdfs.create!(file: Rack::Test::UploadedFile.new('spec/fixtures/sample.pdf'))
    expect(note.pdfs.count).to eq(1)
  end
end
