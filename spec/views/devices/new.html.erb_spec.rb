require 'rails_helper'

RSpec.describe "devices/new", :type => :view do
  before(:each) do
    assign(:device, Device.new(
      :external_id => "MyString",
      :title => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new device form" do
    render

    assert_select "form[action=?][method=?]", devices_path, "post" do

      assert_select "input#device_external_id[name=?]", "device[external_id]"

      assert_select "input#device_title[name=?]", "device[title]"

      assert_select "input#device_description[name=?]", "device[description]"
    end
  end
end
