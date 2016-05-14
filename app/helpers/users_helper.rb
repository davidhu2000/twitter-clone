module UsersHelper
  
  #Returns the gravatar for the given user
  def gravatar_for(user, options = { size: 100} )
    size = options[:size]
    gravatar_hash = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_hash}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
