# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#User.new()

#raise "Due to bugs, you can't use a seed file. You need to run <project_path>/db/pythonseed.py."

puts "If no data gets imported, run <project_path>/db/pythonseeds.py and try again."
puts Dir.pwd
system "python pythonseed.py"
CONN = ActiveRecord::Base.connection
CONN.execute("set autocommit=0")
CONN.execute("set unique_checks=0")
begin
  puts "deleting data"
  CONN.execute("delete from users")
  CONN.execute("delete from profiles")
  CONN.execute("delete from friends")
  
  begin
    puts "CREATE INDEX inviter_id_index ON friends (inviter_id)"
    CONN.execute("CREATE INDEX inviter_id_index ON friends (inviter_id)")
    
    
    puts "CREATE INDEX invitee_id_index ON friends (invitee_id)"
    CONN.execute("CREATE INDEX invitee_id_index ON friends (invitee_id)")
    
    
    puts "CREATE INDEX small_id_index ON friends (small_id)"
    CONN.execute("CREATE INDEX small_id_index ON friends (small_id)")
    
    puts "CREATE INDEX big_id_index ON friends (big_id)"
    CONN.execute("CREATE INDEX big_id_index ON friends (big_id)")
    
  #Rails apparently isn't letting me catch the specific type of exception.
  rescue
    puts "Indices were already created."
  end
  
  puts "loading /tmp/userdata.txt into srvivr_dev.users"
  CONN.execute("LOAD DATA INFILE '/tmp/userdata.txt' INTO TABLE srvivr_dev.users")
  puts "loading /tmp/profiles.txt into srvivr_dev.profiles"
  CONN.execute("LOAD DATA INFILE '/tmp/profiledata.txt' INTO TABLE srvivr_dev.profiles")
  puts "loading /tmp/friends.txt into srvivr_dev.friends"
  CONN.execute("LOAD DATA INFILE '/tmp/frienddata.txt' INTO TABLE srvivr_dev.friends")
ensure
  CONN.execute("set unique_checks=1")
  CONN.execute("set autocommit=1")
end
puts "done"
