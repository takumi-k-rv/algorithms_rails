# coding: utf-8
require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let!(:user) {FactoryBot.build(:user)}
  let!(:post) {FactoryBot.build(:post)}

  it "正常系" do
    expect(FactoryBot.create(:bookmark, post: post, user: user)).to be_valid
  end

  # Assosiation
  it {should belong_to(:user)}
  it {should belong_to(:post)}
end
