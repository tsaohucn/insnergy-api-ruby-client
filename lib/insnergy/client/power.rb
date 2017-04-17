module Insnergy
  module Client
    class Power

      attr_accessor :device_ids, :start_time, :end_time 
      attr_reader :response

      def initialize(client: nil, device_ids: [], start_time: nil, end_time: nil)
        @access_token = client.access_token
        @user_id = client.user_id
        @domain = client.domain
        @device_ids = device_ids
        @dev_ids = ''
        device_ids = Array(device_ids)
        device_ids.each do |ele|
          @dev_ids += ele
          @dev_ids += ';'
        end
        @start_time = start_time
        @end_time = end_time
        @response = nil
        response!
      end   

      def response!
        parameter = {:params => {:apsystem => "IFA", :email => @user_id, :attr => "dm1mi", :start_time => @start_time, :end_time => @end_time, :dev_ids => @dev_ids}, :Authorization => "Bearer #{@access_token}"}
        @response = JSON.parse(RestClient.get "#{@domain}/if/3/device/history_ext", parameter)
        raise "#{response['err']['code']}" unless response['err']['code'] == '0' 
        @response      
      end

    end    
  end
end