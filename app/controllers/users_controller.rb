class UsersController < ApplicationController
  
  hobo_user_controller  
  
  auto_actions :all, :lifecycle, :except => :index
  
  show_action :dashboard, :tutorial, :pending, :unsubscribe
  
  # Allow only the omniauth_callback action to skip the condition that
  # we're logged in. my_login_required is defined in application_controller.rb.
  skip_before_filter :my_login_required, :only => :omniauth_callback
  
  after_filter :update_data, :only => :omniauth_callback
      
  include HoboOmniauth::Controller
  
  include RestController
  
  def create_auth_cookie
    cookies[:auth_token] = { :value => "#{current_user.remember_token} #{current_user.class.name}",
                                   :expires => current_user.remember_token_expires_at, :domain => :all }
  end
  
  def do_accept_invitation
    do_transition_action :accept_invitation do
      self.current_user = model.find(params[:id])
      redirect_to home_page
    end
  end
  
  def do_activate
    do_transition_action :activate do
      self.current_user = model.find(params[:id])
      redirect_to home_page
    end
  end
  
  def admin_only
      render :text => "Permission Denied", :status => 403 unless current_user.administrator?
  end
  
  def dashboard
    redirect_to current_user
  end
  
  def show
    begin
      current_user.all_companies.load
      current_user.all_hoshins.load
      self.this = User.includes({:user_companies => {:company => :active_hoshins}})
        .order('lower(companies.name) asc, lower(hoshins.name) asc').references(:company, :hoshin)
        .user_find(current_user, params[:id])
      raise Hobo::PermissionDeniedError if self.this.nil?
      @tasks = self.this.dashboard_tasks.load
      @indicators = self.this.dashboard_indicators.load
      name = self.this.name.nil? ? self.this.email_address : self.this.name
      @page_title = I18n.translate('user.dashboard_for', :name => name, 
        :default => 'Dashboard for ' + name)     
      hobo_show
    rescue Hobo::PermissionDeniedError => e
      self.current_user = nil
      redirect_to "/login?force=true"
    end
  end
  
  def login
    unless params[:force]
      hobo_login do
        if performed?
          redirect_to home_page 
        else
          true #continue normal hobo_login behavior
        end
      end
    end
  end
    
  
  def pending
    begin
      current_user.all_companies.load
      current_user.all_hoshins.load
      self.this = User.includes({:user_companies => {:company => :active_hoshins}})
        .order('lower(companies.name) asc, lower(hoshins.name) asc').references(:company, :hoshin)
        .user_find(current_user, params[:id])
      @tasks = self.this.pending_tasks.load
      @indicators = self.this.pending_indicators.load
      @page_title = I18n.translate('user.pending_actions_for', :name => self.this.name, 
        :default => 'Pending actions for ' + self.this.name)      
    rescue Hobo::PermissionDeniedError => e
      self.current_user = nil
      redirect_to "/login?force=true"
    end
  end
  
  def unsubscribe
    @this = find_instance
  end

  def tutorial
    @this = find_instance
  end
  
  def logout_and_return
    logout_current_user
    redirect_to params["return_url"]
  end
  
  # Normally, users should be created via the user lifecycle, except
  #  for the initial user created via the form on the front screen on
  #  first run.  This method creates the initial user.
  def create
    hobo_create do
      if valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_are_site_admin", :default=>"You are now the site administrator")
        redirect_to home_page
      end
    end
    people_set
  end
  
  def update
    ajax = request.xhr?
    self.this = find_instance
    
    if self.this.timezone.nil? && !cookies[:tz].nil?
   	  zone = cookies[:tz]
   	  zone = Hoshinplan::Timezone.get(zone)
      self.this.timezone = zone.name unless zone.nil?
    end
    if params[:user] && params[:user][:preferred_view]
      ajax = true
    end
    if params[:tutorial_step] 
      step = params[:tutorial_step].to_i
      if step == 1
        self.this.tutorial_step << self.this.next_tutorial
      elsif step == -1
        self.this.tutorial_step.pop
      elsif step > 1
        self.this.tutorial_step = User.values_for_tutorial_step
      elsif step < -1
        self.this.tutorial_step = []
      end
      if !params[:user]
        params[:user] = {}
      end
      params[:user][:tutorial_step] = self.this.tutorial_step
      ajax = true
    end
    hobo_update do
      if ajax
        flash[:notice] = nil
        hobo_ajax_response
      else
        redirect_to current_user, :dgv => Time.now.to_i if valid?
      end
    end
    people_set
  end
  
  def update_data
    auth = request.env["omniauth.auth"]
    provider = auth['provider']
    uid = auth['uid']
    email = auth['info']['email']
    firstName = auth['info']['firstName']
    lastName = auth['info']['lastName']
    firstName ||= auth['info']['first_name']
    lastName ||= auth['info']['last_name']
    current_user.update_data_from_authorization(provider, uid, email, firstName, lastName, request.remote_ip, cookies[:tz], header_locale)
  end
  
  
  def sign_in(user) 
    sign_user_in(user)
  end
  
  def sign_user_in(user, password=nil)
    params[:remember_me] = true
    if (password.nil?)
      super(user) {remember(user)}
    else
      super(user, password) {remember(user)}
    end
  end
  
  def remember(user)
    current_user.remember_me if logged_in?
    create_auth_cookie if logged_in?
  end
  
  def omniauth
  end
  
end
