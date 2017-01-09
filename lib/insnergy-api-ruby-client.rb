require 'json'
require 'rest-client'

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

  class Widget
    attr_reader :widget_alias, :widget_dev_id, :widget_dev_type_name, :widget_status, :new_infos
    
    def initialize(opts = {})
      @infos = Hash.new
      @new_infos = Hash.new
      @widget_dev_id = opts['dev_id']
      @widget_dev_type_name = opts['dev_type_name']
      @widget_alias = opts['alias']
      @widget_status = opts['status']
      opts['widget_infos'].each do |ele|
        @new_infos[ele['info_desc']] = { id: ele['info_id'], name: ele['info_name'], value: ele['info_value']}
        @infos[ele['info_name']] = ele['info_value']
      end
    end

    def widget_info_value
      self."#{@widget_dev_type_name}"
    end

    def co_meter
      @infos['400700']
    end

    def co2_meter
      @infos['400600']
    end

    def sensor_th_ty
      "#{@infos['400100']}|#{@infos['400200']}"
    end      
  end
end

=begin
  class Power
    attr_reader :device_type_pointer, :type, :month_total_power_value, :alias

    def initialize(opts = {})
      @device_type_pointer = opts['devices'][0].keys.include? 'sub_dev_id'
      case device_type_pointer
      when true
        device_is_multiple_hole(opts)
      when false
        device_is_single_hole(opts)
      end
    end

    def device_is_multiple_hole(opts)
      @type = "multiple hole"
      holes = opts['devices'][0]['data'][0]['value'].split(';')
      names = opts['devices'][0]['sub_alias'].to_s.split(';') 
      for i in 1..holes.size 
        self.class.send(:attr_reader, "hole_#{i}_power_value", "hole_#{i}_alias")  
        instance_variable_set("@hole_#{i}_power_value", holes[i - 1].to_f)
        instance_variable_set("@hole_#{i}_alias", names[i - 1].split('|')[1].split(':')[1])  
      end
    end

    def device_is_single_hole(opts)
      @type = "single hole"
      @month_total_power_value = opts['devices'][0]['data'][0]['value'].to_f
      @alias = opts['devices'][0]['alias']
    end
  end
=end