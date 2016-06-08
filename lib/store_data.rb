
class Store_data

  def initialize(data, type, time_arr)
    @data = data
    @time_arr = time_arr
    managers() if type == "manager" or "all"
  end

  def managers()
    name = @data["name"]
    CSV.open(report_file, "a+") do |csv|
      csv << name, \
        @data["ip_address"], \
        @data["version"], \
        (@data["chef_status"]?("fail"):("ok")), \
        node["cpu"]["0"]["model_name"], node.cpu.total.to_s, \
        node.memory.total, \
        @time_arr.each do |time|
        performance_data[time][name]["cpu"]["average"].to_s, \
        performance_data[time][name]["cpu"]["max"].to_s, \
        performance_data[time][name]["memory"]["average"].to_s, \
        performance_data[time][name]["memory"]["max"].to_s, \
        performance_data[time][name]["load_1"]["average"].to_s, \
        performance_data[time][name]["load_1"]["max"].to_s, \
        performance_data[time][name]["disk_load"]["average"].to_s, \
        performance_data[time][name]["disk_load"]["max"].to_s, \
      end
    end
  end
end