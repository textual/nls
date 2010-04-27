# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def show_time(a_time)
    a_time.hour
  end
  
  def real_currency(price)
    number_to_currency(price ) # ,:delimiter => ".", :unit => "$ ",:separator => ",")
  end
  
  def show_stars(rated = nil)
    html = ""
    html  = <<HTML
      <ul class="rating #{rated ? rated.en.numwords : "no" }star">
         <li class="one">1</li>
         <li class="two">2</li>
         <li class="three">3</li>
         <li class="four">4</li>
         <li class="five">5</li>
      </ul>
HTML
  end
  
  def show_stars_to_rate(rated = nil)
    html = ""
    html  = <<HTML
      <ul class="rating #{rated ? rated.en.numwords : "no" }star">
         <li class="one">#{link_to_remote( "1" , {:url => { :controller => "event_dates", :action => "rate", :id => 35, :rating => 1}} ) }</li>
         
                     
         <li class="two">2</li>
         <li class="three">3</li>
         <li class="four">4</li>
         <li class="five">5</li>
      </ul>
HTML
    
  end
  
  def format_content(content)
     # Allow only tags specified in tags options, likewise in attributes
     content = sanitize(content, :tags => %w(b strong i em img), :attributes => %w(src))
     # Add Support for Line Breaks
     content = simple_format(content)
     # Autolink Urls and Emails
     content = auto_link(content, :all, :target => '_blank')
     # Return it, baby
     return content
   end
end
