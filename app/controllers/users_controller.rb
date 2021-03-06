class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!   You're now logged in and ready to go!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again."
      render :action => 'new'
    end
  end
  
  def forgot  
    if request.post?  
      user = User.find_by_email(params[:user][:email])  

      respond_to do |format|  
        if user  
          user.create_reset_code  
          flash[:notice] = "Reset code sent to #{user.email}"  

          format.html { redirect_to login_path }  
          format.xml { render :xml => user.email, :status => :created }  
        else  
          flash[:error] = "#{params[:user][:email]} does not exist in system"  

          format.html { redirect_to login_path }  
          format.xml { render :xml => user.email, :status => :unprocessable_entity }  
        end  
      end  

    end  
  end
  
  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?  
      if request.post?  
        if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])  
          self.current_user = @user  
          @user.delete_reset_code  
          flash[:notice] = "Password reset successfully for #{@user.email}"  
          redirect_to root_url  
        else  
          if @user != nil
            render :action => :reset  
          else
            flash[:error] = "no email found with reset code"
            redirect_to :signup  
          end
        end  
      end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  
  def link_user_accounts
    if self.current_user.nil?
      #register with fb
      User.create_from_fb_connect(facebook_session.user)
    else
      #connect accounts
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    redirect_to '/'
  end
  
end
