module ATEM

	class Switcher

		def initialize config
			@config = config
			@inputs = []
		end

		def connect

			@airtower = ATEM::Network.new @config[:ip], @config[:port], @config[:uid]

			response = @airtower.hello
			response.each { | c | handle c }


		end

		def handle packet

			p packet

		end

		def disconnect

			@airtower.disconnect

		end

		def inputs
			@inputs
		end

	end

end