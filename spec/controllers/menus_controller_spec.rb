require "rails_helper"

RSpec.describe Api::V1::MenusController, :type => :controller do
  describe "Test Menus Controller" do

    before(:each) do
      @user = User.create(email: 'test@qr-menu.rest', password: 'test')
      @token = Auth.create_token(@user)
      @file = fixture_file_upload('test.pdf', 'application/pdf')
    end

    it "can upload a menu (create action)" do
      post :create, params: {token: @token, file: @file, file_name: 'testing_menu_upload'}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)["last_file"]['has_file']).to be(true)
      expect(JSON.parse(response.body)["last_file"]['file_name']).to eq('testing_menu_upload')
      expect(JSON.parse(response.body)["last_file"]['pdf_file']).to_not be_nil
      expect(JSON.parse(response.body)["last_file"]['qr_code']).to_not be_nil
      expect(JSON.parse(response.body)["last_file"]['uploaded']).to_not be_nil
      expect(JSON.parse(response.body)["last_file"]['id']).to eq(1)
    end

    it "can upload a demo menu (demo_upload action)" do
      post :demo_upload, params: {file: @file}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)['pdf_file']).to_not be_nil
      expect(JSON.parse(response.body)['qr_code']).to_not be_nil
    end

    it 'finds menus if user is logged in and passing a token from local storage' do
      menu = Menu.new(user: @user)
      menu.pdf_file.attach(@file)
      menu.save
      get :find_menus, params: {token: @token}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)['last_file']['has_file']).to be(true)
    end

    it 're-sends qr_code (resend_qr_code) action' do
      menu = Menu.new(user: @user)
      menu.pdf_file.attach(@file)
      menu.save
      post :resend_qr_code, params: {token: @token}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["status"]).to eq("success")
    end

    it 'pulls out data for demo controller consistently' do
      menu = Menu.new(user: User.create(email: 'demo@qr-menu.rest', password: 'demo'))
      menu.pdf_file.attach(@file)
      menu.save
      get :demo
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'destroys the menu' do
      menu = Menu.new(user: @user)
      menu.pdf_file.attach(@file)
      menu.save
      post :destroy, params: {token: @token, id: 1}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['status']).to eq('success')
      expect(Integer(JSON.parse(response.body)['id'])).to eq(menu.id)
    end
  
  end
end