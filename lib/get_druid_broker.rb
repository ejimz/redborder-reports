#!/usr/bin/env ruby

class Get_druid_broker
  def initialize(random = true)
    @random = random
  end

  def print_broker(zk, zk_id)
    zktdata,stat = zk.get("/druid/discoveryPath/broker/#{zk_id}")
    zktdata = YAML.load(zktdata)
  end

  def get_brokers
    zk_host="localhost:2181"
    config=YAML.load_file('/opt/rb/etc/managers.yml')
    if !config["zookeeper"].nil? or !config["zookeeper2"].nil?
      zk_host=((config["zookeeper"].nil? ? [] : config["zookeeper"].map{|x| "#{x}:2181"}) + (config["zookeeper2"].nil? ? [] : config["zookeeper2"].map{|x| "#{x}:2182"})).join(",")
      zk = ZK.new(zk_host)
      brokers = zk.children("/druid/discoveryPath/broker").map{|k| k.to_s}.sort.uniq.shuffle

      if @random
        print_broker(zk, brokers.first)
      else
        brokers.each do |b|
          print_broker(zk, b)
        end
      end
    end
  end
end