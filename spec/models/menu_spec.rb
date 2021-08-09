require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'Test Menu Model' do

    it 'is not valid without user' do
      user = User.create(email:'test@qr-menu.rest', password: 'test')
      expect(Menu.new()).to_not be_valid
      expect(Menu.new(user: user)).to be_valid
    end

    it "is has file attached" do
      menu = Menu.new(user: User.create(email: 'test@qr-menu.rest', password: 'test'))
      menu.qr_code.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(menu.qr_code).to be_attached
    end

  end
end