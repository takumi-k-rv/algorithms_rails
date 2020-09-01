# coding: utf-8
require 'rails_helper'

RSpec.describe Post, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let!(:user) {FactoryBot.create(:user)}

  it "正常系" do
    expect(FactoryBot.create(:post, user: user)).to be_valid
  end

  # Assosiation
  it {should belong_to(:user)}

  # Validation
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:content)}
  it {should validate_presence_of(:code)}

end