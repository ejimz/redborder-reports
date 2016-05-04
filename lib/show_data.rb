require 'colorize'

class Show_data

  def initialize(data, type)
  	@data = data
    managers() if type == "managers" or "all"
  end

  def managers()
      #  puts "======================================"
    name = @data["name"]
    puts "Manager Node Name  -> " + @data["name"]
    puts "Manager IP Address  -> " + @data["ip_address"]
    puts "version -> " + @data["version"]
    puts "Chef -> " + @data["chef_status"]
    puts "CPU Model -> " + @data["cpu_model"]
    puts "CPUs -> " + @data["cpus"]
    puts "Memory -> " + @data["memory"]
    #
    #Metrics for 1 hour
    puts "1 hour Metric CPU Average -> " + @data["performance"][1][name]["cpu"]["average"].to_s
    puts "1 hour Metric CPU Max -> " + @data["performance"][1][name]["cpu"]["max"].to_s
    puts "1 hour Metric Memory Average -> " + @data["performance"][1][name]["memory"]["average"].to_s
    puts "1 hour Metric Memory Max -> " + @data["performance"][1][name]["memory"]["max"].to_s
    puts "1 hour Metric Load Average -> " + @data["performance"][1][name]["load_1"]["average"].to_s
    puts "1 hour Metric Load Max -> " + @data["performance"][1][name]["load_1"]["max"].to_s
    puts "1 hour Metric Disk Load Average -> " + @data["performance"][1][name]["disk_load"]["average"].to_s
    puts "1 hour Metric Disk Load Max -> " + @data["performance"][1][name]["disk_load"]["max"].to_s
#
    #Metrics for 3 hours
    puts "3 hours Metric CPU Average -> " + @data["performance"][3][name]["cpu"]["average"].to_s
    puts "3 hours Metric CPU Max -> " + @data["performance"][3][name]["cpu"]["max"].to_s
    puts "3 hours Metric Memory Average -> " + @data["performance"][3][name]["memory"]["average"].to_s
    puts "3 hours Metric Memory Max -> " + @data["performance"][3][name]["memory"]["max"].to_s
    puts "3 hours Metric Load Average -> " + @data["performance"][3][name]["load_1"]["average"].to_s
    puts "3 hours Metric Load Max -> " + @data["performance"][3][name]["load_1"]["max"].to_s
    puts "3 hours Metric Disk Load Average -> " + @data["performance"][3][name]["disk_load"]["average"].to_s
    puts "3 hours Metric Disk Load Max -> " + @data["performance"][3][name]["disk_load"]["max"].to_s
#
    #Metrics for 12 hours
    puts "12 hours Metric CPU Average -> " + @data["performance"][12][name]["cpu"]["average"].to_s
    puts "12 hours Metric CPU Max -> " + @data["performance"][12][name]["cpu"]["max"].to_s
    puts "12 hours Metric Memory Average -> " + @data["performance"][12][name]["memory"]["average"].to_s
    puts "12 hours Metric Memory Max -> " + @data["performance"][12][name]["memory"]["max"].to_s
    puts "12 hours Metric Load Average -> " + @data["performance"][12][name]["load_1"]["average"].to_s
    puts "12 hours Metric Load Max -> " + @data["performance"][12][name]["load_1"]["max"].to_s
    puts "12 hours Metric Disk Load Average -> " + @data["performance"][12][name]["disk_load"]["average"].to_s
    puts "12 hours Metric Disk Load Max -> " + @data["performance"][12][name]["disk_load"]["max"].to_s
#
    #Metrics for 1 day (24 hours)
    puts "1 day Metric CPU Average -> " + @data["performance"][24][name]["cpu"]["average"].to_s
    puts "1 day Metric CPU Max -> " + @data["performance"][24][name]["cpu"]["max"].to_s
    puts "1 day Metric Memory Average -> " + @data["performance"][24][name]["memory"]["average"].to_s
    puts "1 day Metric Memory Max -> " + @data["performance"][24][name]["memory"]["max"].to_s
    puts "1 day Metric Load Average -> " + @data["performance"][24][name]["load_1"]["average"].to_s
    puts "1 day Metric Load Max -> " + @data["performance"][24][name]["load_1"]["max"].to_s
    puts "1 day Metric Disk Load Average -> " + @data["performance"][24][name]["disk_load"]["average"].to_s
    puts "1 day Metric Disk Load Max -> " + @data["performance"][24][name]["disk_load"]["max"].to_s
#
    #Metrics for 1 week (168 hours)
    puts "1 week hour Metric CPU Average -> " + @data["performance"][168][name]["cpu"]["average"].to_s
    puts "1 week hour Metric CPU Max -> " + @data["performance"][168][name]["cpu"]["max"].to_s
    puts "1 week hour Metric Memory Average -> " + @data["performance"][168][name]["memory"]["average"].to_s
    puts "1 week hour Metric Memory Max -> " + @data["performance"][168][name]["memory"]["max"].to_s
    puts "1 week hour Metric Load Average -> " + @data["performance"][168][name]["load_1"]["average"].to_s
    puts "1 week hour Metric Load Max -> " + @data["performance"][168][name]["load_1"]["max"].to_s
    puts "1 week hour Metric Disk Load Average -> " + @data["performance"][168][name]["disk_load"]["average"].to_s
    puts "1 week hour Metric Disk Load Max -> " + @data["performance"][168][name]["disk_load"]["max"].to_s

  end

end
