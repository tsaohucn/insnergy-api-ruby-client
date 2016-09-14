module Insnergy

  class Client
    attr_accessor :domain, :oauth_key, :oauth_secert, :refresh_token
	  attr_reader :access_token, :user_id

	  def initialize(domain: nil, oauth_key: nil, oauth_secert: nil, refresh_token: nil)
	    @domain = domain
      @oauth_key = oauth_key
	    @oauth_secert = oauth_secert
	    @refresh_token = refresh_token
	    @user_id = nil
	    refresh!
      user_id!
	  end

	  def refresh!
      response = JSON.parse(RestClient.post "#{@domain}/if/oauth/token" ,{:client_id => @oauth_key, :client_secret => @oauth_secert, :absytem => 'IFA', :grant_type => 'refresh_token', :refresh_token => @refresh_token }, :accept => :json)
      raise "<refresh_token is nil>\n#{response}" unless response['refresh_token'] != nil
      raise "<access_token is nil>\n#{response}" unless response['access_token'] != nil
      @refresh_token = response['refresh_token']
      @access_token = response['access_token']		
	  end

	  def user_id!
      response = JSON.parse(RestClient.get "#{@domain}/if/3/user/me" ,{:Authorization => "Bearer #{@access_token}"})
      raise "<user_id is nil>\n#{response}" unless response['user']['user_id'] != nil
      @user_id = response['user']['user_id']
	  end

	  def sensor
		  Client::Sensor.new(client: self, category: 'sensor')
	  end

    def power(device_id: nil, start_time: nil, end_time: nil)
      client = Client::Power.new(client: self, device_id: device_id, start_time: start_time, end_time: end_time)
      client.get_device
    end
  end

  class Client::Power
    attr_reader :access_token, :user_id, :device_type_pointer

    def initialize(client: nil, device_id: nil, start_time: nil, end_time: nil)
      @access_token = client.access_token
      @user_id = client.user_id
      @domain = client.domain
      @device_id = device_id
      @start_time = start_time
      @end_time = end_time
    end

    def get_device
      Power.new(get_response)
    end

    def get_response
      parameter = {:params => {:apsystem => "IFA", :email => @user_id, :attr => "dm1mi", :start_time => @start_time, :end_time => @end_time, :dev_ids => @device_id}, :Authorization => "Bearer #{@access_token}"}
      response = JSON.parse(RestClient.get "#{@domain}/if/3/device/history_ext", parameter)
      response      
    end
  end

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
      @power_value = opts['devices'][0]['data'][0]['value'].to_f
      @alias = opts['devices'][0]['alias']
    end
  end

  class Client::Sensor
    attr_reader :access_token, :user_id, :widgets

    def initialize(client: nil,category: nil)
      @access_token = client.access_token
      @user_id = client.user_id
      @domain = client.domain
      @category = category
      get_device
    end

    def get_device
      @widgets = Array.new
      get_response['widgets'].each do |ele|
          @widgets << Sensor.new(ele)
      end 
    end

    def each
      @widgets.each do |ele|
        yield ele
      end
    end

    def get_response
      parameter = {:params => {:apsystem => "IFA", :email => @user_id, :type_code => 1, :dev_category => "#{@category}"}, :Authorization => "Bearer #{@access_token}"}
      response = JSON.parse(RestClient.get "#{@domain}/if/3/user/widgets", parameter)
      raise "err code is not zero\n#{response}" unless response['err']['code'] == '0'  
      response
    end
  end

  class Sensor
    attr_reader :widgets_alias, :dev_id, :dev_type_name, :status

    def initialize(opts = {})
      @infos = Hash.new
      @widgets_alias = opts['alias']
      @dev_id = opts['dev_id']
      @dev_type_name = opts['dev_type_name']
      @status = opts['status']
      opts['widget_infos'].each do |ele|
        @infos[ele['info_name']] = ele['info_value']
      end
    end

    def widgets_info_value
      @dev_type_name
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