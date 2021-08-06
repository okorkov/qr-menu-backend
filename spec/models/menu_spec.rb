require 'rails_helper'

RSpec.describe Menu, type: :model do

  it 'is not valid without user' do
    user = User.create(email:'test@qr-menu.rest', password: 'test')
    expect(Menu.new()).to_not be_valid
    expect(Menu.new(user: user)).to be_valid
  end

end