require 'net/http'
require 'digest/md5'
require 'uri'

CLEVERBOT_WEBSERVICE = "http://cleverbot.com/webservicemin"

# array indices
INDEX_STIMULUS		=	0
INDEX_START		=	1
INDEX_SESSIONID		=	2
INDEX_VTEXT8		=	3
INDEX_VTEXT7		=	4
INDEX_VTEXT6		=	5
INDEX_VTEXT5		=	6
INDEX_VTEXT4		=	7
INDEX_VTEXT3		=	8
INDEX_VTEXT2		=	9
INDEX_ICOGNOID		=	10
INDEX_ICOGNOCHECK	=	11
INDEX_FNO		=	12
INDEX_PREVREF		=	13
INDEX_EMOTIONALOUTPUT	=	14
INDEX_EMOTIONALHISTORY	=	15
INDEX_ASBOTNAME		=	16
INDEX_TTSVOICE		=	17
INDEX_TYPING		=	18
INDEX_LINEREF		=	19
INDEX_SUB		=	20
INDEX_ISLEARNING	=	21
INDEX_CLEANSLATE	=	22
# using a hash would be easier, but those aren't sorted

class CleverBot

	def initialize
		initPostData
		@boturi = URI.parse(CLEVERBOT_WEBSERVICE)
	end

	def reset
		initPostData
	end

	def query(phrase)
		pushLog(phrase)

		getAnswer
	end

private

	def pushLog(phrase)
		@postData[INDEX_VTEXT8][1] = @postData[INDEX_VTEXT7][1]
		@postData[INDEX_VTEXT7][1] = @postData[INDEX_VTEXT6][1]
		@postData[INDEX_VTEXT6][1] = @postData[INDEX_VTEXT5][1]
		@postData[INDEX_VTEXT5][1] = @postData[INDEX_VTEXT4][1]
		@postData[INDEX_VTEXT4][1] = @postData[INDEX_VTEXT3][1]
		@postData[INDEX_VTEXT3][1] = @postData[INDEX_VTEXT2][1]
		@postData[INDEX_VTEXT2][1] = @postData[INDEX_STIMULUS][1]
		@postData[INDEX_STIMULUS][1] = phrase
	end

	def getAnswer
		botserver = Net::HTTP.new(@boturi.host, @boturi.port)

		data = buildPostString

		@postData[INDEX_ICOGNOCHECK][1] = Digest::MD5.hexdigest(data[9 .. 28])

		data = buildPostString

		resp = botserver.post(boturi.request_uri, data)

		ans = resp.body.reverse

		7.times do
			ans = ans[(ans.index("\r")+1)...ans.length] if ans.index("\r") != nil
		end

		ans = ans[0 .. (ans.index("\r")-1)] if ans.index("\r") != nil

		ans.reverse!

		pushLog(ans)

		ans
	end

	def buildPostString
		data = ""

		@postData.each do |pair|
			data += pair[0]
			data += "="
			data += pair[1]
			data += "&"
		end

		URI.encode(data.chop)
		
	end

	def initPostData
		@postData = [
			["stimulus", ""],
			["start", "y"],
			["sessionid", ""],
			["vText8", ""],
			["vText7", ""],
			["vText6", ""],
			["vText5", ""],
			["vText4", ""],
			["vText3", ""],
			["vText2", ""],
			["icognoid", "wsf"],
			["icognocheck", ""],
			["fno", "0"],
			["prevref", ""],
			["emotionaloutput", ""],
			["emotionalhistory", ""],
			["asbotname", ""],
			["ttsvoice", ""],
			["typing", ""],
			["lineref", ""],
			["sub", "Say"],
			["islearning", "1"],
			["cleanslate", "false"]
		]
	end

end
