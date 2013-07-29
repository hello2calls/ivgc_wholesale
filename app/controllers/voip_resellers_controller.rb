require 'mail'

class VoipResellersController < ApplicationController
  def index
  end
  def voipResellerSignUp

  	to = "sales@ivgc.net"
	session[:first_name] = params[:first_name]
	session[:last_name] = params[:last_name]
	session[:email] = params[:email]
	session[:phone] = params[:phone]
	session[:comments] = params[:comments]

	from = params[:email]
	full_name = params[:first_name] + " " + params[:last_name]
	subject = "IVGC Reseller Sign Up from Website: " + full_name + " from " + params["country"]["country_name"]
	phone = params[:phone].gsub(/[^0-9]/, "")
	country_name = params["country"]["country_name"]
	language = params[:language]
	business = params[:business]
	revenue = params[:revenue]
	comments = params[:comments]
    error = signup_error(params[:first_name], params[:last_name], params[:email], phone)
    if error.nil?
		options = { :address              => "smtp.gmail.com",
		           :port                 => 587,
		           :domain               => 'ciaotelecom.net',
		           :user_name            => 'its.ciaotelecom@gmail.com',
		           :password             => 'Ci402013',
		           :authentication       => 'plain',
		           :enable_starttls_auto => true  }
		Mail.defaults do
			delivery_method :smtp, options
		end
	
		begin 
			Mail.deliver do
		   		to 'sales@ivgc.net'
		   		from "#{from}"
		   		subject "#{subject}"
		   		#body "hi"
		   		body "Sender Name: #{full_name} \n\nEmail: #{from} \n\nPhone: #{phone} \n\nCountry: #{country_name} \n\nLanguage: #{language} \n\nBusiness: #{business} \n\nMonthly Revenue: #{revenue}  \n\nComments: #{comments}"
			end
	 	redirect_to "/voip_resellers/thanksForSigningUp"

		rescue Exception => e
	 		flash[:error] = "You message was not sent! Please try again!"
	 		redirect_to voip_resellers_path
		end
	else
		flash[:error] = error
      	redirect_to voip_resellers_path
    end
 end 

 def thanksForSigningUp
 	@full_name = session[:first_name] + " " + session[:last_name]	
 end

  def signup_error(first_name, last_name, email, phone)
    # first validate form fields
    if first_name.length == 0
    	return 'First name can not be null'
    elsif last_name.length == 0
    	return 'Last name can not be null'
    elsif not validate_email(email)
      	return 'Email is not valid'
    elsif not validate_phone(phone)
      	return 'Phone Number is not valid'
    end
  end

end
