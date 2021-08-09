require "rails_helper"

RSpec.describe UsersController, :type => :controller do
  describe "Test Users Controller" do

    before(:each) do
      @user = User.create(email: 'test@qr-menu.rest', password: 'test')
      @token = Auth.create_token(@user)
    end


    it "creates user with valid credentials" do
      post :create, params: {email: 'test-register@qr-menu.rest', password: 'test', password_confirmation: 'test'}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["token"]).to_not be_nil
    end

    it "fails if user with this email already exists" do
      post :create, params: {email: 'test@qr-menu.rest', password: 'test', password_confirmation: 'test'}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["errors"]).to_not be_nil
      expect(JSON.parse(response.body)["logged_in"]).to be(false)
    end

    it "fails if password doesnt match password confirmation" do
      post :create, params: {email: 'test-register@qr-menu.rest', password: 'test1', password_confirmation: 'test2'}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["errors"]).to_not be_nil
      expect(JSON.parse(response.body)["logged_in"]).to be(false)
    end

    it "generates new qr for qr-menu" do
      post :generate_qr_for_menu, params: {token: @token, domain: 'qr-menu.rest/menu/1'}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["status"]).to eq('success')
      expect(@user.qr_code).to be_attached
    end

    it "uploads file and attaches it to the user instance" do
      file = fixture_file_upload('test.pdf', 'application/pdf')
      post :upload_file, params: {token: @token, file: file}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["status"]).to eq('success')
      expect(@user.file).to be_attached
    end

    it "gets menu based off passed user id" do
      file = fixture_file_upload('test.pdf', 'application/pdf')
      @user.file.attach(file)
      @user.file_link = @user.file.url.sub(/\?.*/, '')
      @user.save
      get :get_menu, params: {id: 1}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["has_file"]).to be(true)
      expect(JSON.parse(response.body)["menu_link"]).to_not be_nil
    end

    it "returns has_file: false json if no file attached to user" do
      get :get_menu, params: {id: 1}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["has_file"]).to be(false)
    end

    it "resends qr code to user's mail" do
      post :resend_qr_menu, params: {token: @token}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["status"]).to eq('success')
    end
  
  end
end