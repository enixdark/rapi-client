require_relative 'base'
require 'active_support'
require 'rest-client'
module Rapi
	class Connect < Rapi::Base
		@@field = [:token, :client_id, :category, :content]

		attr :email, :password, :uri, :token, :client_id

		def initialize(uri = "http://localhost:3000", email = "abc123@example.com",
			 password = "12345678")
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

		def get_all_messages(page = 1)
      request do
      	JSON.parse(RestClient.get "#{uri}/api/v1/messages",
      	{ :params => default_params.merge({ :page => page })})
      end
		end

		def get_message(id)
			request do
      	JSON.parse(RestClient.get "#{uri}/api/v1/messages/#{id}", { :params => default_params})
      end
		end

		def create_message(**kwargs)
			request do
      	JSON.parse(RestClient.post "#{uri}/api/v1/messages", 
      		require(default_params.merge(kwargs),@@field))
      end
		end

		def update_message(**kwargs)
			request do
      	JSON.parse(RestClient.put "#{uri}/api/v1/messages", 
      		require(default_params.merge(kwargs),@@field))
      end
		end

		def delete_message(id)
			request do
      	JSON.parse(RestClient.delete "#{uri}/api/v1/messages/#{id}", {:params => default_params})
      end
		end




		private
		  # check access token and client id before request
		  def request
        unless @token
        	raise InvalidAccessTokenError
        end
        unless @client_id
        	raise InvalidClientIdError
        end
        if block_given?
          yield
        end
		  end

		  def require(data, *args)
		  	data.slice(*args.flatten)
		  end

		  def default_params
        { :token => @token, :client_id => @client_id}
		  end
	end
end
