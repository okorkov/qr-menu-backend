require 'rails_helper'

RSpec.describe Link, type: :model do

  it 'is not valid without user' do
    user = User.create(email:'test@qr-menu.rest', password: 'test')
    expect(Link.new()).to_not be_valid
    expect(Link.new(user: user)).to be_valid
  end

  it "is has file attached" do
    link = Link.new(user: User.create(email: 'test@qr-menu.rest', password: 'test'))
    link.qr_code.attach(
      io: File.open(Rails.root.join('spec', 'fixtures', 'test.pdf')),
      filename: 'test.pdf',
      content_type: 'application/pdf'
    )
    expect(link.qr_code).to be_attached
  end

end