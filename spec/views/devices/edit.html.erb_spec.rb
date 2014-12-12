require 'rails_helper'

RSpec.describe "devices/edit", :type => :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      :external_id => "MyString",
      :title => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit device form" do
    render

    assert_select "form[action=?][method=?]", device_path(@device), "post" do

      assert_select "input#device_external_id[name=?]", "device[external_id]"

      assert_select "input#device_title[name=?]", "device[title]"

      assert_select "input#device_description[name=?]", "device[description]"
    end
  end
end
