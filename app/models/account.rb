require "rubygems"
require "sequel"
class Account < ActiveRecord::Base
  #DB = Sequel.connect("mysql2://reports:u2ns8uj28yshu@208.65.111.153:3306/porta-billing")
  def self.authenticate(login, password)
    #@url = "https://208.65.111.144/rest/Session/login/{'login':'soap-webpanel','password':'wsw@c@8am'}"
    #@uri = URI.encode(@url.gsub!("'", '"'))
   # @response = RestClient::Request.new(
    #  :method => :post,
    #  :url => @uri,
    #  :headers => { :accept => :json, :content_type => :json}).execute

    #@result = ActiveSupport::JSON.decode(@response)

    @url = "https://208.65.111.144/rest/Account/get_account_list/%7B%22session_id%22:%22a36a398ebd51edcea8ac936b21fa299c%22%7D/%7B%22i_customer%22:%221552%22%7D"
    @response = RestClient::Request.new(
      :method => :post,
      :url => @url,
      :headers => { :accept => :json, :content_type => :json}).execute
    @result = ActiveSupport::JSON.decode(@response)
    @result["account_list"].each do |account|
      if account["login"] == login
       if account["password"] == password
       return account
       else
       return nil
       end
      end
    end
    return nil
  end
end