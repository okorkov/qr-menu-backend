require "rails_helper"

RSpec.describe Api::V1::LinksController, :type => :controller do

    before(:each) do
      @user = User.create(email: 'test@qr-menu.rest', password: 'test')
      @token = Auth.create_token(@user)
      @link = Link.new(user: @user)
    end

    it "creates new link with proper json response" do
      post :create, params: {token: @token, input: 'https://qr-menu.rest'}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["address"]).to eq('https://qr-menu.rest')
      expect(JSON.parse(response.body)['qr_code']).to_not be_nil
      expect(JSON.parse(response.body)['id']).to eq(@user.id)
    end

    it "deletes the link" do
      @link.save
      post :destroy, params: {token: @token, id: '1'}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["status"]).to eq('success')
      expect(Integer(JSON.parse(response.body)['id'])).to eq(@link.id)
    end

end