class AccountsController < ApplicationController
  def index
    if not session[:current_login]
      redirect_to "/sessions/new"
    end
  end

  def accountInfo
    if session[:current_login]
      @url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{@@session_id}'}/{'i_customer':'1552', 'i_account':'#{params[:i_account]}'}"
      @result = apiRequest(@url)
    else
      flash[:error] = " Please login to continue! "
      redirect_to root_path
    end
  end

  def accountTerminate
    if session[:current_login]
      @url = "https://208.65.111.144/rest/Account/terminate_account/{'session_id':'#{@@session_id}'}/{'i_account':'#{params[:i_account]}'}"
      @result = apiRequest(@url)
    else
      flash[:error] = " Please login to continue! "
      redirect_to root_path
    end
  end

  def accountList
    if session[:current_login]
      @url = "https://208.65.111.144/rest/Account/get_account_list/{'session_id':'#{@@session_id}'}/{'i_customer':'1552'}"
      @result = apiRequest(@url)
    else
      flash[:error] = " Please login to continue! "
      redirect_to root_path
    end
  end

  def updateAccount
    # in this method, I get the account info and pass the necessary to the forms where user see what current info they have
    # and then can change it there and pass to another method whether the request for update will be sent.

    if session[:current_login]
      @url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{@@session_id}'}/{'i_customer':'1552', 'i_account':'#{session[:i_account]}'}"
      @result = apiRequest(@url)
    else
      flash[:error] = "Please login to continue!"
      redirect_to root_path
    end
    @comp_name = @result["account_info"]["companyname"]
    @user_name = @result["account_info"]["login"]
    @comp_name = @result["account_info"]["companyname"]
    @e_mail = @result["account_info"]["subscriber_email"]
    @ip = @result["account_info"]["id"]
  end

  def doUpdate
    if not session[:current_login]
      flash[:error] = "Please login to continue!"
      return redirect_to root_path
    end
    @company_name = params[:companyname]
    @login = params[:username]
    @password = params[:password]
    @email = params[:email]

    if not validate_login(@login)
      flash[:error] = "Username cannot have fewer than 6 characters"
      return redirect_to "/accounts/updateAccount"
    elsif not validate_pw(@password)
      flash[:error] = "Password cannot have fewer than 6 characters"
      return redirect_to "/accounts/updateAccount"
    elsif not validate_email(@email)
      flash[:error] = "Email is not valid"
      return redirect_to "/accounts/updateAccount"
    end
    @url = "https://208.65.111.144/rest/Account/update_account/{'session_id':'#{@@session_id}'}/{'account_info':{'i_account':'#{session[:i_account]}','subscriber_email':'#{@email}','login':'#{@login}','password':'#{@password}', 'companyname':'#{@company_name}'}}"
    @result = apiRequest(@url)
           
    if @result["i_account"].nil?
      flash[:error] = "Oops! Try again!"
      redirect_to "accounts/updateAccount"
    else 
      flash[:notice] = "You successfully updated your account infos"
      redirect_to root_path
    end
  end

  def manageIP
    @url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{@@session_id}'}/{'i_customer':'1552', 'i_account':'#{session[:i_account]}'}"
    @result = apiRequest(@url)
    @primary = @result["account_info"]["id"]
  end

  def updateIP
    puts "UPDATEEE"
    puts params.inspect
    puts session[:i_account]
    @url = "https://208.65.111.144/rest/Account/add_alias/{'session_id':'#{@@session_id}'}/{'alias_info':{'i_account':'#{session[:i_account]}', 'blocked':'Y', 'id':'#{params[:secondary_id]}', 'i_master_account':'#{session[:i_account]}'}}"
    @result = apiRequest(@url)
  end

end
 
#working methods for accounts
#https://208.65.111.144/rest/Session/login/{"login":"soap-webpanel","password":"wsw@c@8am"}
#https://208.65.111.144/rest/Account/get_account_list/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_customer":"1552"}
#https://208.65.111.144/rest/Account/get_account_info/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_customer":"1552","i_account":"877783"}
#https://208.65.111.144/rest/Account/update_account/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"account_info":{"i_account":"877771","subscriber_email":"ciaotest@ciao.com","login":"ciaotest","password":"ciaotest"}}
#https://208.65.111.144/rest/Account/terminate_account/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_account":"877771"}
#https://208.65.111.144/rest/Account/add_alias/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"alias_info":{"i_account":"877771","blocked":"Y","id":"23.43.13.3","i_master_account":"877783"}}



