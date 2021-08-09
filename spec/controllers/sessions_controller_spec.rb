require "rails_helper"

RSpec.describe SessionsController, :type => :controller do

  it "creates token after success user authentication" do
    user = User.create(email: 'test@qr-menu.rest', password: 'test')
    post :create, params: {email: 'test@qr-menu.rest', password: 'test'}
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(JSON.parse(response.body)["token"]).to_not be_nil
  end

  it "fails authentication if wrong credentials are passed" do
    user = User.create(email: 'test@qr-menu.rest', password: 'test')
    post :create, params: {email: 'test@qr-menu.rest', password: 'wrong_password'}
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(JSON.parse(response.body)["errors"]).to eq('Email or Password is incorrect')
  end

  it "verify that user is logged in with proper token being passed on" do
    user = User.create(email: 'test@qr-menu.rest', password: 'test')
    token = Auth.create_token(user)
    post :is_logged_in?, params: {token: token}
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["logged_in"]).to be(true)
  end

  it "google auth authenticates already existing user by email" do
    user = User.create(email: 'test@qr-menu.rest', password: 'test')
    post :google_auth, params: {email: 'test@qr-menu.rest', idpid: ENV['ADPID']}
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["logged_in"]).to be(true)
  end

  it "google auth creates user by email if none found" do
    post :google_auth, params: {email: 'test@qr-menu.rest', idpid: ENV['ADPID']}
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["logged_in"]).to be(true)
  end

  it "google auth failes if wrong adpid is passed" do
    post :google_auth, params: {email: 'test@qr-menu.rest', idpid: 'wrong_id'}
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["errors"]).to eq('failed oauth')
  end

end