module Insnergy  
  module Client
    class Token

      attr_accessor :domain, :oauth_key, :oauth_secert, :refresh_token
      attr_reader :access_token, :user_id, :expires_at

      def initialize(domain: nil, oauth_key: nil, oauth_secert: nil, refresh_token: nil)
        @domain = domain
        @oauth_key = oauth_key
        @oauth_secert = oauth_secert
        @refresh_token = refresh_token
        @access_token = nil
        @user_id = nil
        token!
        user_id!
      end

      def token!
        response = JSON.parse(RestClient.post "#{@domain}/if/oauth/token" ,{:client_id => @oauth_key, :client_secret => @oauth_secert, :absytem => 'IFA', :grant_type => 'refresh_token', :refresh_token => @refresh_token }, :accept => :json)
        raise "<no got refresh_token>\n#{response}" unless response.key?('refresh_token')
        raise "<no got access_token>\n#{response}" unless response.key?('access_token')
        @refresh_token = response['refresh_token']
        @access_token = response['access_token']    
      end

      def user_id!
        response = JSON.parse(RestClient.get "#{@domain}/if/3/user/me" ,{:Authorization => "Bearer #{@access_token}"})
        raise "<no got user_id>\n#{response}" unless response.key?('user') && response['user'].key?('user_id')
        @user_id = response['user']['user_id']
        @expires_at = Time.at(response['token']['expires_at']/1000)
      end

      def ok?
        begin
          JSON.parse(RestClient.get "#{@domain}/if/3/user/me" ,{:Authorization => "Bearer #{@access_token}"})
          return true
        rescue Exception => e
          if %w(401\ Unauthorized 7104).include? e.message
            return false
          else
            raise e
          end
        end
      end
      
    end    
  end
end