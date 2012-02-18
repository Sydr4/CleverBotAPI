require 'cleverBot'

bot = CleverBot.new
puts "CleverBot Shell v#{VERSION}"

while true do
	print ">"
	puts bot.query(gets)
end
