class Get_druid_data

  def initialize(broker_host, broker_port,post_ws,query,type)
    @broker_host = broker_host
    @broker_port = broker_port
    @post_ws = post_ws
    @query = query
    @type = type
  end

  def get_data
    response = http_query(@broker_host,@broker_port,@post_ws,@query.to_json)
    data = JSON.parse(response)
    data_ordered = order_by_sensor(data)
    return data_ordered
  end

  def order_by_sensor(data)
    h_ordered = {}
    puts data
    data.each do |d|
      sensor_name = d["event"]["sensor_name"]
      if @type == "performance"
        event_type = d["event"]["monitor"]
        h_ordered[sensor_name] = {} if h_ordered[sensor_name].nil?
        h_ordered[sensor_name][event_type] = {} if h_ordered[sensor_name][event_type].nil?
        h_ordered[sensor_name][event_type]["average"] = d["event"]["average"]
        h_ordered[sensor_name][event_type]["max"] = d["event"]["max"]
     elsif @type == "events_ips"
        event_type = "events_ips"
        h_ordered[sensor_name] = {} if h_ordered[sensor_name].nil?
        h_ordered[sensor_name][event_type] = {} if h_ordered[sensor_name][event_type].nil?
        h_ordered[sensor_name][event_type]["events"] = d["event"]["events"]
        h_ordered[sensor_name][event_type]["eventsPerSec"] = d["event"]["eventsPerSec"].to_s
      elsif @type == "events_flow"
        event_type = "events_flow"
        h_ordered[sensor_name] = {} if h_ordered[sensor_name].nil?
        h_ordered[sensor_name][event_type] = {} if h_ordered[sensor_name][event_type].nil?
        h_ordered[sensor_name][event_type]["events"] = d["event"]["events"]
        h_ordered[sensor_name][event_type]["eventsPerSec"] = d["event"]["eventsPerSec"].to_s
      elsif @type == "throughput"
        event_type = "throughput"
        h_ordered[sensor_name] = {} if h_ordered[sensor_name].nil?
        h_ordered[sensor_name][event_type] = {} if h_ordered[sensor_name][event_type].nil?
        h_ordered[sensor_name][event_type]["sum_bytes"] = d["event"]["sum_bytes"]
        h_ordered[sensor_name][event_type]["avg_Mbps"] = d["event"]["avg_Mbps"]
      end
    end
    return h_ordered
  end

  def http_query(host, port, post_ws, query)
    req = Net::HTTP::Post.new(post_ws, initheader = {'Content-Type' =>'application/json'})
    req.body = query
    response = Net::HTTP.new(host, port).start {|http| http.request(req) }
    return response.body
  end
end