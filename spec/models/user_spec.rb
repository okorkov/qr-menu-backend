require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "is valid with valid attributes (email and password)" do
    expect(User.new(email:'test@qr-menu.rest', password: 'test')).to be_valid
  end

  it "is not valid without an email" do
    expect(User.new(password: 'test')).to_not be_valid
  end

  it "is not valid without a password" do 
    expect(User.new(email:'test@qr-menu.rest')).to_not be_valid
  end

  it 'is only valid with unique email addresses' do
    valid_user = User.create(email:'test@qr-menu.rest', password: 'test')
    invalid_user = User.new(email:'test@qr-menu.rest', password: 'test')
    expect(invalid_user).to_not be_valid
  end

  it 'is valid with proper email address' do
    expect(User.new(email:'test@qr-menu.rest', password: 'test')).to be_valid
    expect(User.new(email:'Matt@gmail.com', password: 'test')).to be_valid
    expect(User.new(email:'idontwannagivemyemail', password: 'test')).to_not be_valid
    expect(User.new(email:'Matt@gmail.1com', password: 'test')).to_not be_valid
  end

end
