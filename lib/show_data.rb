require 'colorize'

class Show_data

  def initialize(data, type, time_arr)
  	@data = data
  	@time_arr = time_arr
    managers() if type == "manager" or "all"
  end

  def managers()
    name = @data["name"]

    puts "======================================"
    puts "Manager Node Name  -> " + @data["name"]
    puts "Manager IP Address  -> " + @data["ip_address"]
    puts "version -> " + @data["version"]
    puts "Chef -> " + @data["chef_status"]
    puts "CPU Model -> " + @data["cpu_model"]
    puts "CPUs -> " + @data["cpus"]
    puts "Memory -> " + @data["memory"]
    
    @time_arr.each do |time|
      puts "#{time} hours Metric CPU Average -> " + @data["performance"][time][name]["cpu"]["average"].to_s
      puts "#{time} hours Metric CPU Max -> " + @data["performance"][time][name]["cpu"]["max"].to_s
      puts "#{time} hours Metric Memory Average -> " + @data["performance"][time][name]["memory"]["average"].to_s
      puts "#{time} hours Metric Memory Max -> " + @data["performance"][time][name]["memory"]["max"].to_s
      puts "#{time} hours Metric Load Average -> " + @data["performance"][time][name]["load_1"]["average"].to_s
      puts "#{time} hours Metric Load Max -> " + @data["performance"][time][name]["load_1"]["max"].to_s
      puts "#{time} hours Metric Disk Load Average -> " + @data["performance"][time][name]["disk_load"]["average"].to_s
      puts "#{time} hours Metric Disk Load Max -> " + @data["performance"][time][name]["disk_load"]["max"].to_s
    end

  end

end
