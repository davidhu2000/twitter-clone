require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    
    #assert user.count does not change after code runs
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", 
                               email: "user@invalid", 
                               password: "dude", 
                               password_confirmation: "bar" }
    end
   
    assert_template 'users/new'
  end
  
  test "valid sign infomration" do
    get signup_path
    
    #assert user.count does not change after code runs
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "David", 
                                            email: "user@valid.com", 
                                            password: "dudeyeah", 
                                            password_confirmation: "dudeyeah" }
    end
    assert_template 'users/show'
  end
  
  
end