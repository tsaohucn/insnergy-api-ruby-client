require './lib/insnergy-api-ruby-client'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # other config options here...    

end

describe Insnergy::Client do
  #before(:all) do #itri-tomato.project@insnergy.com
  #  domain = 'https://if3.insnergy.com'
  #  oauth_key = 'aac61d6e-b9df-4cf6-a44e-dbba0518b339'
  #  oauth_secert = 'ffaa37d1-74eb-42db-a555-91aa59d4f540'
  #  refresh_token = 'a8f1cea8-ff8e-4e88-b280-551eafe894a7'
  #  @insnergy = Insnergy::Client::Token.new(domain: domain, oauth_key: oauth_key, oauth_secert: oauth_secert, refresh_token: refresh_token)  
  #end
=begin
  describe Insnergy::Client::Token do
    before(:all) do
      @access_token = @insnergy.access_token
      @user_id = @insnergy.user_id
      @expires_at = @insnergy.expires_at
    end 

    describe "#initialize" do
    	context "when initialize a new object" do
  	    it "must exist access_token" do
  	      expect(@access_token).not_to eq(nil)
          p @access_token
  	    end

  	    it "must exist user_id" do
  	  	  expect(@user_id).not_to eq(nil)
          p @user_id
  	    end

        it "must exist expires_at" do
          expect(@expires_at).not_to eq(nil)
          p @expires_at
        end        
  	  end
    end

    describe "#ok?" do
      it 'return true' do
        expect(@insnergy.ok?).to eq(true)
        p @insnergy.ok?
      end
    end

    describe "#token!" do
    	context "when excute token!" do
    	  before do	
    	    @insnergy.token!
    	  end

    	  it "must get different access_token" do
    	  	expect(@insnergy.access_token).not_to eq(@access_token)
    	  end
    	end
    end

    describe "#user_id!" do
    	context "when excute user_id!" do
    	  before do	
    	    @insnergy.user_id!
    	  end

    	  it "must get same user_id" do
    	  	expect(@insnergy.user_id).to eq(@user_id)
    	  end
    	end
    end
  end

  describe Insnergy::Client::Widgets do
    before(:all) do
    	@widgets = Insnergy::Client::Widgets.new(client: @insnergy, category: 'sensor')
    end 

    describe "#initialize" do
    	context "when initialize a new object" do
  	    it "must exist response" do
  	  	  @sensor_response = @widgets.response
  	      expect(@sensor_response).not_to eq(nil)
  	      #puts @sensor_response
  	    end
      end 

  	  context "when change object's category" do
        before(:all) do
          @widgets.category = 'outlet'
          @widgets.response!
          @outlet_response = @widgets.response
          @widgets.category = 'gateway'
          @widgets.response!
          @gateway_response = @widgets.response
        end      
          
        it "must exist response" do
  	      expect(@outlet_response).not_to eq(nil)
  	      #puts @outlet_response
  	    end	

  	    it "must exist response" do
  	      expect(@gateway_response).not_to eq(nil)
  	      #puts @gateway_response
  	    end

  	    it "it's response must different" do
  	  	  expect(@outlet_response).not_to eq(@sensor_response)
  	  	  expect(@gateway_response).not_to eq(@sensor_response)
  	    end
  	  end
    end
  end

  describe Insnergy::Client::Power do
    
    def this_month_day1
      Time.new(2016,01,01).to_i*1000
    end

    def next_month_day1
      Time.new(2016,02,01).to_i*1000
    end  

    before(:all) do
    	device_ids = ['RS06000D6F0003BB8B88','II09000D6F0003BBAE83']	
     	@power = Insnergy::Client::Power.new(client: @insnergy, device_ids: device_ids, start_time: this_month_day1, end_time: next_month_day1)
    end 

    describe "#initialize" do
  	  context "when initialize a new object" do
  	    it "must exist response" do
  	      expect(@power.response).not_to eq(nil)
  	      #puts @client_power.response
  	    end
  	  end
    end
  end
=end
  describe Insnergy::Client::Control do
    #before(:all) do
    #  @device_id = 'II09000D6F0003BBAE83'
    #  @control = Insnergy::Client::Control.new(client: @insnergy, device_id: @device_id, action: 'on')
    #end 
    
    describe "#initialize" do
      context "when initialize a new object" do
        it "must exist response" do
    domain = 'https://if3.insnergy.com'
    #oauth_key = 'aac61d6e-b9df-4cf6-a44e-dbba0518b339'
    #oauth_secert = 'ffaa37d1-74eb-42db-a555-91aa59d4f540'
    #refresh_token = 'a8f1cea8-ff8e-4e88-b280-551eafe894a7'
    #device_id = 'RS06000D6F0003BB8B88'
    uid = 'itri-tomato.project@insnergy.com'
    token = '4069e83d-cb14-4fed-8d40-10b6f1fa3934'
    device_id = "RS06000D6F0003BB8B88#01|II09000D6F0003BBAE83|RS06000D6F0003BB8B88#01|II09000D6F0003BBAE83".split('|').map{|ele| ele.split('#').first}
    #insnergy = Insnergy::Client::Token.new(domain: domain, oauth_key: oauth_key, oauth_secert: oauth_secert, refresh_token: refresh_token)           
    Client = Struct.new(:domain, :access_token, :user_id)
    insnergy = Client.new(domain, token, uid)

    #insnergy = Insnergy::Client::Token.new(domain: domain, oauth_key: oauth_key, oauth_secert: oauth_secert, refresh_token: refresh_token)           
          #p insnergy
          p device_id
          control_response = Array.new()
          10.times do
            device_id.each do |ele|
              control = Insnergy::Client::Control.new(client: insnergy, device_id: ele, action: 'on')
              puts '....'
              control_response << control.response
            end
          end
          p control_response
          #expect(@control_response).not_to eq(nil)
        end

        #it "response'structre must exist relay_status and br on" do
          #@control_response = @control.response
          #expect(@control_response['relay_status']).to eq('on')
        #end
      end 
    end    

  end
end