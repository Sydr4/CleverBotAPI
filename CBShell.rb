require 'cleverBot'

bot = CleverBot.new
puts "CleverBot Shell"

while true do
	print ">"
	puts bot.query(gets)
end
