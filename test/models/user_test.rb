require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Sterling", email: "archer@isis.com", password: "foobar", password_confirmation: "foobar")  
  end
  
  test "user should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "       "
    assert_not @user.valid?
  end
  
  test "name should be less than 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "       "
    assert_not @user.valid?
  end
  
  test "email should be less than 250 characters" do
    @user.email = "a" * 251
    assert_not @user.valid?
  end
  
  test "email should accept valid addresses" do
    valid_addresses = %w[david@gmail.com michael@ee.com USER@foot.COM 
                        A_US-ER@foot.bar.org first.last@foot.jp alice+bob@baz.cn]
    valid_addresses.each do |email|
      @user.email = email
      assert @user.valid?, "#{valid_addresses.inspect} should be valid"
    end
  end
  
  test "email should reject invalid addresses" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foot@bar_baz.com foo@bar+baz.com]
                           
    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{invalid_addresses.inspect} should be invalid"
    end
  end
  
  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
   
  test "password should be more than 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end 
  
  test "authenticated? should be return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "Associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Testing")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end 
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user not appear in feed
    archer.microposts.each do |post_unfollow|
      assert_not michael.feed.include?(post_unfollow)
    end
  end
  
end
