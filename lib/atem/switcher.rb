module ATEM

	class Switcher

		attr_reader :version, :product, :topology, :video_mode

		def initialize config
			@config = config
			@inputs = ATEM::Switcher::InputCollection.new self

		end

		def connect

			@airtower = ATEM::Network.new @config[:ip], @config[:port], @config[:uid]

			response = @airtower.hello
			# @airtower.send! "FTSU", "\x0" * 12
			response.each { | c | handle c }

		end

		def handle packet

			# p packet

			case packet[0]
			when "_ver"

				@version = packet[1].unpack("S>S>")

			when "_pin"

				@product = packet[1].unpack("a20")[0]

			when "_top"

				top = ["MEs", "Sources", "Colour Generators", "AUX busses", "DSKs", "Stingers", "DVEs", "SuperSources"]
				@topology = Hash[top.zip(packet[1].unpack("CCCCCCCC"))]

			when "VidM"

				@video_mode = packet[1].unpack("C")

			when "InPr"

				input = ATEM::Switcher::Input.from packet[1], self
				@inputs.add input 

			end

		end

		def disconnect

			@airtower.disconnect

		end

		def inputs
			@inputs
		end

		def preview id
			@airtower.send! "CPvI", [0, 0, id].pack("CCS>")
		end

		def program id
			@airtower.send! "CPgI", [0, 0, id].pack("CCS>")
		end

	end

end