require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
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
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid sign infomration" do
    get signup_path
    
    #assert user.count does not change after code runs
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "David", 
                               email: "user@valid.com", 
                               password: "dudeyeah", 
                               password_confirmation: "dudeyeah" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    
    # Try to log in before activating.
    log_in_as(user)
    assert_not is_logged_in?
    
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.nil?
    #assert_not_nil flash
  end 
  
  test "valid signup information with account activation" do
    get signup_path
    name = "Walter White"
    email = "user@example.com"
    password = "foobar"
    assert_difference 'User.count', 1 do
      post users_path, user: { name:                  name,
                               email:                 email,
                               password:              password,
                               password_confirmation: password }
    end
    assert_equal ActionMailer::Base.deliveries.count, 1
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # Index page
    # Log in as valid user
    log_in_as(users(:michael))
    # Unactivated user is on the second page
    get users_path, page: 4
    assert_no_match user.name, response.body
    # Log out valid user.
    delete logout_path
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
end


