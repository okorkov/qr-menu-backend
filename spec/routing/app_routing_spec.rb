require "rails_helper"

RSpec.describe "Routes", :type => :routing do

  it "route '/' to point root page, application#welcome" do
    expect(get("/")).
      to route_to("application#welcome")
  end

  it "route /google_auth to point to the sessions#google_auth" do
    expect(post("/google_auth")).
      to route_to("sessions#google_auth")
  end

  it "route /logged_in to point to the sessions#is_logged_in?" do
    expect(post("/logged_in")).
      to route_to("sessions#is_logged_in?")
  end

  it "route /logout to point to the sessions#destroy" do
    expect(delete("/logout")).
      to route_to("sessions#destroy")
  end

  it "route /login to point to the sessions#create" do
    expect(post("/login")).
      to route_to("sessions#create")
  end

  it "route /users to point to the users#create" do
    expect(post("/users")).
      to route_to("users#create")
  end

  it "route /resend_qr_menu to point to the users#resend_qr_menu" do
    expect(post("/resend_qr_menu")).
      to route_to("users#resend_qr_menu")
  end

  it "route /get_menu/:id to point to the users#get_menu" do
    expect(get("get_menu/1")).
      to route_to(controller: "users", action: 'get_menu', id: '1')
  end

  it "route /upload_file to point to the users#upload_file" do
    expect(post("/upload_file")).
      to route_to("users#upload_file")
  end

  it "route /generate_qr_for_menu to point to the users#generate_qr_for_menu" do
    expect(post("/generate_qr_for_menu")).
      to route_to("users#generate_qr_for_menu")
  end

  it "route /api/v1/menus/:id to point to the menus#destroy" do
    expect(post("/api/v1/menus/1")).
    to route_to(controller: "api/v1/menus", action: 'destroy', id: '1')
  end

  it "route /api/v1/demo_upload to point to the menus#demo_upload" do
    expect(post("/api/v1/demo_upload")).
      to route_to("api/v1/menus#demo_upload")
  end

  it "route /api/v1/resend_qr_code to point to the menus#resend_qr_code" do
    expect(post("/api/v1/resend_qr_code")).
      to route_to("api/v1/menus#resend_qr_code")
  end

  it "route /api/v1/demo to point to the menus#demo" do
    expect(get("/api/v1/demo")).
      to route_to("api/v1/menus#demo")
  end

  it "route /api/v1/find_menus to point to the menus#find_menus" do
    expect(post("/api/v1/find_menus")).
      to route_to("api/v1/menus#find_menus")
  end

  it "route /api/v1/links/:qr_code_address to point to the links#destroy" do
    expect(post("/api/v1/links/destroy_link")).
    to route_to(controller: "api/v1/links", action: 'destroy', qr_code_address: 'destroy_link')
  end

  it "route /api/v1/links to point to the links#create" do
    expect(post("/api/v1/links")).
      to route_to("api/v1/links#create")
  end

end