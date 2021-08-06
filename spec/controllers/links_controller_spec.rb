require "rails_helper"

RSpec.describe Api::V1::LinksController, :type => :controller do
  describe "responds to" do

    before(:each) do
      @user = User.create(email: 'test@qr-menu.rest', password: 'test')
      @token = Auth.create_token(@user)
      @link = Link.new()
    end

    it "is has file attached" do
      @link.qr_code.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(@link.qr_code).to be_attached
    end

    # it "responds to custom formats when provided in the params" do
    #   post :create, params: { token: @token, input: 'https://qr-menu.rest'}
    #   expect(response.content_type).to eq "application/json; charset=utf-8"
    # end

  end
end