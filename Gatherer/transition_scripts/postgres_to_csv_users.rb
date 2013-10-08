# This script moves the csv file contents into the postgres database for the app.  It contains many printing 
# statements to make it clear if the data is being transferred correctly.

require 'csv'
require 'pg'

class Relayer

counter = 0
insert_counter = 0
conn = PGconn.connect('dbname=backup')
res  = conn.exec('select * from users')

res.each do |row|
   # Debugging output
   puts row["id"]
   puts row["email"]
   puts row["name"]



   CSV.open("app_users.csv", "wb") do |csv|
                      csv <<  [ "|negative|","|#{(content_array[0])}|",
                                          "|#{reply_1}|","|#{reply_2}|","|#{reply_3}|","|#{reply_4}|","|#{reply_5}|" ]
                    end
  
end

end


