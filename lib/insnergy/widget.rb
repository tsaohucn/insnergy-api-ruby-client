module Insnergy
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
      self.send(:"#{@widget_dev_type_name.downcase}")
    end

    def co_meter
      @infos['400700']
    end

    def co2_meter
      @infos['400600']
    end

    def sensor_th_hy
      "#{@infos['400100']}|#{@infos['400200']}"
    end

  end  
end