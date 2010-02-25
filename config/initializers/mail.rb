# config/initializers/mail.rb  

ActionMailer::Base.delivery_method = :smtp 
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_content_type = "text/html" 
ActionMailer::Base.smtp_settings = {  
    :address => "smtp.gmail.com", 
    :port => 587,   
    :enable_starttls_auto => true,
    :user_name => "mr.dan.marks@gmail.com", 
    :password => "g0flyers"  
}