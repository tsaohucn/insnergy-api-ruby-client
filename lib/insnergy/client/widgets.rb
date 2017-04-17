module Insnergy
  module Client
    class Widgets

      attr_accessor :category, :client 
      attr_reader :response

      def initialize(client: nil,category: nil)
        @access_token = client.access_token
        @user_id = client.user_id
        @domain = client.domain
        @category = category
        @response = nil
        response!
      end

      def response!
        parameter = {:params => {:apsystem => "IFA", :email => @user_id, :type_code => 1, :dev_category => "#{@category}"}, :Authorization => "Bearer #{@access_token}"}
        @response = JSON.parse(RestClient.get "#{@domain}/if/3/user/widgets", parameter)
        raise "#{response['err']['code']}" unless response['err']['code'] == '0'  
        @response
      end
      
    end    
  end
end