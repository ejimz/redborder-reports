#!/usr/bin/env ruby
#######################################################################
## Copyright (c) 2014 ENEO Tecnología S.L.
## This file is part of redBorder.
## redBorder is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## redBorder is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## You should have received a copy of the GNU General Public License
## along with redBorder. If not, see <http://www.gnu.org/licenses/>.
########################################################################

require 'chef'
require 'ansi'
require 'csv'
require 'json'
require 'net/http'
require 'rubygems'
require 'resolv-replace'
require 'zk'
require 'json'
require 'yaml'
require 'getopt/std'
require '/opt/rb/var/reports/lib/get_druid_broker'
require '/opt/rb/var/reports/lib/get_druid_data'
require '/opt/rb/var/reports/lib/show_data'

config_dir = "/opt/rb/etc/reports"
lib_dir = "/opt/rb/var/reports/lib"
query_performance_file = "query_performance.json"
query_events_ips_file = "query_events_ips.json"
query_events_flow_file = "query_events_flow.json"
query_throughput_file = "query_throughput.json"

query_performance = JSON.parse(IO.read("#{config_dir}/#{query_performance_file}"))
query_events_ips = JSON.parse(IO.read("#{config_dir}/#{query_events_ips_file}"))
query_events_flow = JSON.parse(IO.read("#{config_dir}/#{query_events_flow_file}"))
query_throughput_flox = JSON.parse(IO.read("#{config_dir}/#{query_throughput_file}"))


getbdruid = Get_druid_broker.new(random = true)
get_random_broker = getbdruid.get_brokers
broker_druid = "#{get_random_broker['address']}:#{get_random_broker['port']}"

broker_host = broker_druid.split(':')[0]
broker_port = broker_druid.split(':')[1]
post_ws = "/druid/v2/?pretty=true"

#time array in hours
time_arr = [1,3,12,24,168]

performance_data = {}
ips_data = {}
flow_data = {}

for i in time_arr
  minutes = 60 * 60 * i

  start_time = (Time.now - minutes).iso8601
  end_time = Time.now.iso8601
  intervals = "#{start_time}/#{end_time}"
  query_performance["intervals"] = intervals
  query_events_ips["intervals"] = intervals
  query_events_flow["intervals"] = intervals
  #query_throughput["intervals"] = intervals

  # get performance data
  gdruid = Get_druid_data.new(broker_host, broker_port,post_ws,query_performance, "performance")
  performance_data[i] = gdruid.get_data
#
#  # get ips events
#  gdruid = Get_druid_data.new(broker_host, broker_port,post_ws,query_events_ips, "events_ips")
#  ips_data[i] = gdruid.get_data

  # get flow_events
#  gdruid = Get_druid_data.new(broker_host, broker_port,post_ws,query_events_flow, "events_flow")
#  flow_data = gdruid.get_data
  
end


## Chef config
Chef::Config.from_file("/etc/chef/client.rb")
Chef::Config[:node_name]  = "rb-chef-webui"
Chef::Config[:client_key] = "/opt/rb/var/www/rb-rails/config/rb-chef-webui.pem"
Chef::Config[:http_retry_count] = 5

report_dir = "/opt/rb/var/reports/result/"

index_times_arr = ["1 hour", "3 hours", "12 hours", "1 day", "1 week"]
index_metrics = ["CPU Average","CPU Max","Memory Average", "Memory Max", "Load Average", \
                  "Load Max", "Disk Load Average", "Disk Load Max"]
report_file = "#{report_dir}/manager-nodes-report.csv"
file_column_index =  "# Manager Node Name, Manager IP, Version, Chef, CPU Model\
 ,CPUs, Memory"

index_times_arr.each do |times_txt|
  index_metrics.each do |metrics_txt|
    file_column_index += ",#{times_txt} #{metrics_txt} "
  end
end

if !Dir.exists?(report_dir)
  Dir.mkdir(report_dir)
end

nodes = Chef::Node.list(true)
nodecheck = {}
#
#
File.open(report_file,"wb") { |f| f.puts(file_column_index) }

data = {}

if !nodes.nil? and !nodes.empty?
  nodes.each do |name,node|
    next unless node[:redBorder][:is_manager]
    segment_list = []
    type = "manager"

    data["name"] = name
    data["ip_address"] = node.ipaddress
    data["version"] = node["redBorder"]["rpms"]["manager"]
    data["chef_status"] = ((Time.now.to_i-node[:ohai_time].to_i>600)?("fail"):("ok"))
    data["cpu_model"] = node["cpu"]["0"]["model_name"]
    data["cpus"] = node.cpu.total.to_s
    data["memory"] = node.memory.total
    data["performance"] = {}
    data["performance"] = performance_data
  
    Show_data.new(data, "manager", time_arr)

    CSV.open(report_file, "a+") do |csv|
      csv << [name, node.ipaddress, node["redBorder"]["rpms"]["manager"], \
        ((Time.now.to_i-node[:ohai_time].to_i>600)?("fail"):("ok")), \
        node["cpu"]["0"]["model_name"], node.cpu.total.to_s, \
        node.memory.total,performance_data[1][name]["cpu"]["average"].to_s, \
        performance_data[1][name]["cpu"]["max"].to_s, \
        performance_data[1][name]["memory"]["average"].to_s, \
        performance_data[1][name]["memory"]["max"].to_s, \
        performance_data[1][name]["load_1"]["average"].to_s, \
        performance_data[1][name]["load_1"]["max"].to_s, \
        performance_data[1][name]["disk_load"]["average"].to_s, \
        performance_data[1][name]["disk_load"]["max"].to_s, \
        performance_data[3][name]["cpu"]["average"].to_s, \
        performance_data[3][name]["cpu"]["max"].to_s, \
        performance_data[3][name]["memory"]["average"].to_s, \
        performance_data[3][name]["memory"]["max"].to_s, \
        performance_data[3][name]["load_1"]["average"].to_s, \
        performance_data[3][name]["load_1"]["max"].to_s, \
        performance_data[3][name]["disk_load"]["average"].to_s, \
        performance_data[3][name]["disk_load"]["max"].to_s, \
        performance_data[12][name]["cpu"]["average"].to_s, \
        performance_data[12][name]["cpu"]["max"].to_s, \
        performance_data[12][name]["memory"]["average"].to_s, \
        performance_data[12][name]["memory"]["max"].to_s, \
        performance_data[12][name]["load_1"]["average"].to_s, \
        performance_data[12][name]["load_1"]["max"].to_s, \
        performance_data[12][name]["disk_load"]["average"].to_s, \
        performance_data[12][name]["disk_load"]["max"].to_s, \
        performance_data[24][name]["cpu"]["average"].to_s, \
        performance_data[24][name]["cpu"]["max"].to_s, \
        performance_data[24][name]["memory"]["average"].to_s, \
        performance_data[24][name]["memory"]["max"].to_s, \
        performance_data[24][name]["load_1"]["average"].to_s, \
        performance_data[24][name]["load_1"]["max"].to_s, \
        performance_data[24][name]["disk_load"]["average"].to_s,\
        performance_data[24][name]["disk_load"]["max"].to_s,\
        performance_data[168][name]["cpu"]["average"].to_s,\
        performance_data[168][name]["cpu"]["max"].to_s, \
        performance_data[168][name]["memory"]["average"].to_s, \
        performance_data[168][name]["memory"]["max"].to_s, \
        performance_data[168][name]["load_1"]["average"].to_s, \
        performance_data[168][name]["load_1"]["max"].to_s, \
        performance_data[168][name]["disk_load"]["average"].to_s, \
        performance_data[168][name]["disk_load"]["max"].to_s]

  end
  end
end
# vim:ts=2:sw=4:expandtab:ai:nowrap:formatoptions=croqln:
