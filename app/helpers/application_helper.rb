module ApplicationHelper
  
  def full_title(page_title = "")
    base_title = "Ruby on Rails Tutorial Sample App"
    
    if !page_title.empty?
      line = " | "
    else
      line = ""
    end  
    
    return "#{page_title}#{line}#{base_title}"
  end
end
