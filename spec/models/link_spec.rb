require 'rails_helper'

RSpec.describe Link, type: :model do

  it 'is not valid without user' do
    user = User.create(email:'test@qr-menu.rest', password: 'test')
    expect(Link.new()).to_not be_valid
    expect(Link.new(user: user)).to be_valid
  end


end