# coding: utf-8
require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) {FactoryBot.create(:user)}

  it "正常系" do
    expect(FactoryBot.create(:post, user: user)).to be_valid
  end

  # Assosiation
  it {should belong_to(:user)}

  # Validation
  it {should validate_presence_of(:title)}
  it {should validate_length_of(:title).is_at_most(100)}
  it {should validate_presence_of(:content)}
  it {should validate_length_of(:content).is_at_most(2000)}
  it {should validate_presence_of(:code)}
  it {should validate_length_of(:code).is_at_most(30000)}

end
