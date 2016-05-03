require_relative 'base'
require 'rest-client'
module Rapi
	class Connect < Rapi::Base
		attr :email, :password, :uri, :token, :client_id

		def initialize(uri, email, password)
			@uri = uri
			@email = email
			@password = password
		end

		# get or refresh access token,thet set client_id and token that get from response
		def request_access_token
      response = RestClient.post "#{uri}/api/v1/auth/sign_in",
      {:user => {:email => @email, :password => @password} }
      json_parser = JSON.parse(response)["data"]["resource_json"]
      @client_id = json_parser["client_id"]
      @token = json_parser["token"]
      json_parser
		end

		def get_messages
      request do
      	RestClient.post "#{uri}/api/v1/messages", { :token => @token, @client_id => @client_id}
      end
		end


		private
		  # check access token and client id before request
		  def request
        unless @access
        	raise InvalidAccessTokenError
        end
        unless @client_id
        	raise InvalidClientIdError
        end
        if block_given?
          yield
        end
		  end
	end
end
