require "rails_helper"

RSpec.describe "Routes", :type => :routing do
  describe 'Test Routing' do

    it "route '/' to point root page, application#welcome" do
      expect(get("/")).to route_to("application#welcome")
      expect(get("/")).to be_routable
    end

    it "route /google_auth to point to the sessions#google_auth" do
      expect(post("/google_auth")).to route_to("sessions#google_auth")
      expect(post("/google_auth")).to be_routable
    end

    it "route /logged_in to point to the sessions#is_logged_in?" do
      expect(post("/logged_in")).to route_to("sessions#is_logged_in?")
      expect(post("/logged_in")).to be_routable
    end

    it "route /logout to point to the sessions#destroy" do
      expect(delete("/logout")).to route_to("sessions#destroy")
      expect(delete("/logout")).to be_routable
    end

    it "route /login to point to the sessions#create" do
      expect(post("/login")).to route_to("sessions#create")
      expect(post("/login")).to be_routable
    end

    it "route /users to point to the users#create" do
      expect(post("/users")).to route_to("users#create")
      expect(post("/users")).to be_routable
    end

    it "route /resend_qr_menu to point to the users#resend_qr_menu" do
      expect(post("/resend_qr_menu")).to route_to("users#resend_qr_menu")
      expect(post("/resend_qr_menu")).to be_routable
    end

    it "route /get_menu/:id to point to the users#get_menu" do
      expect(get("get_menu/1")).to route_to(controller: "users", action: 'get_menu', id: '1')
      expect(get("/get_menu/1")).to be_routable
    end

    it "route /upload_file to point to the users#upload_file" do
      expect(post("/upload_file")).to route_to("users#upload_file")
      expect(post("/upload_file")).to be_routable
    end

    it "route /generate_qr_for_menu to point to the users#generate_qr_for_menu" do
      expect(post("/generate_qr_for_menu")).to route_to("users#generate_qr_for_menu")
      expect(post("/generate_qr_for_menu")).to be_routable
    end

    it "route /api/v1/menus/:id to point to the menus#destroy" do
      expect(post("/api/v1/menus/1")).to route_to(controller: "api/v1/menus", action: 'destroy', id: '1')
      expect(post("/api/v1/menus/1")).to be_routable
    end

    it "route /api/v1/demo_upload to point to the menus#demo_upload" do
      expect(post("/api/v1/demo_upload")).to route_to("api/v1/menus#demo_upload")
      expect(post("/api/v1/demo_upload")).to be_routable
    end

    it "route /api/v1/resend_qr_code to point to the menus#resend_qr_code" do
      expect(post("/api/v1/resend_qr_code")).to route_to("api/v1/menus#resend_qr_code")
      expect(post("/api/v1/resend_qr_code")).to be_routable
    end

    it "route /api/v1/demo to point to the menus#demo" do
      expect(get("/api/v1/demo")).to route_to("api/v1/menus#demo")
      expect(get("/api/v1/demo")).to be_routable
    end

    it "route /api/v1/find_menus to point to the menus#find_menus" do
      expect(post("/api/v1/find_menus")).to route_to("api/v1/menus#find_menus")
      expect(post("/api/v1/find_menus")).to be_routable
    end

    it "route /api/v1/links/:id to point to the links#destroy" do
      expect(post("/api/v1/links/destroy_link")).to route_to(controller: "api/v1/links", action: 'destroy', id: 'destroy_link')
      expect(post("/api/v1/links/destroy_link")).to be_routable
    end

    it "route /api/v1/links to point to the links#create" do
      expect(post("/api/v1/links")).to route_to("api/v1/links#create")
      expect(post("/api/v1/links")).to be_routable
    end

  end
end