module Insnergy
  module Client
    class Control

      attr_accessor :device_id, :action
      attr_reader :response
      def initialize(client: nil, device_id: nil, action: nil)
        @access_token = client.access_token
        @user_id = client.user_id
        @domain = client.domain
        @device_id = device_id
        @action = action
        @response = nil
        response!
      end

      def response!
        parameter = {:params => {:apsystem => "IFA", :email => @user_id,  :dev_id => @device_id ,:action => @action}, :Authorization => "Bearer #{@access_token}"}
        @response = JSON.parse(RestClient.get "#{@domain}/if/3/device/control" , parameter)
        raise "#{response['err']['code']}" unless response['err']['code'] == '0' 
        @response 
      end      
    end    
  end
end