require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST login" do
    it "works" do
      post :login, :auth => {'these' => 'params'}, :format => :json
      expect(subject.current_user).to_not eq(nil)
    end
  end
end