# coding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it "正常系" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # Assosiation
  it {should have_many(:posts)}

  # Validation
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:email)}
  it {should validate_uniqueness_of(:email)}
end
