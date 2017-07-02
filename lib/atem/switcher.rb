module ATEM

	class Switcher

		attr_reader :version, :product, :topology, :video_mode, :master

		def initialize config
			@config = config
			@inputs = ATEM::Switcher::InputCollection.new self
			@_audio_by_index = []
		end

		def connect

			@airtower = ATEM::Network.new @config[:ip], @config[:port], @config[:uid]

			response = @airtower.hello
			# @airtower.send! "FTSU", "\x0" * 12
			response.each { | c | handle c }

		end

		# YIKES!
		def handle packet

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

				input = ATEM::Switcher::Input.from packet[1], self, ATEM::Switcher::Input::Type::VIDEO
				@inputs.add input 

			when "AMIP"

				audio_id = packet[1].unpack("S>")[0] #("S>CxxxCCCxS>s>")

				input = @inputs[audio_id]

				if !@inputs[audio_id] 
					input = ATEM::Switcher::Input.new self
					input.init audio_id
					@inputs.add(input)
				end

				input.type |= ATEM::Switcher::Input::Type::AUDIO
				input.audio = ATEM::Switcher::Input::Audio.from packet[1], self, input

			when "AMLv"

				master = {}
				sources, master[:left], master[:right], master[:left_peak], master[:right_peak],
					monitor = packet[1].unpack("S>xxl>l>l>l>l>")

				@master = master
				start_offset = 38 + sources * 2

				(0..sources-1).each do | source |

					source_id = packet[1][(36 + source * 2)..-1].unpack("S>")[0]

					levels = {}

					levels[:left], levels[:right], levels[:left_peak], levels[:right_peak] =
						packet[1][(start_offset + source * 16)..-1].unpack("l>l>l>l>")

					@inputs[source_id].audio.levels = levels

				end

			end

		end

		def disconnect

			@airtower.disconnect

		end

		def inputs
			@inputs
		end

		def multithreading
			@thread != nil
		end

		def multithreading= enabled

			@thread.kill if @thread
			@thread = nil
			return if !enabled

			Thread.abort_on_exception = true
			@thread = Thread.new do

				loop do

					packets = @airtower.receive
					packets.each do | packet |
						handle packet
					end

				end

			end

		end

		def use_audio_levels
			@use_audio_levels
		end

		def use_audio_levels= enabled

			self.multithreading = true if !@thread
			@airtower.send! "SALN", [enabled ? 1 : 0].pack("C") + "\0\0\0"

		end

		def preview id
			@airtower.send! "CPvI", [0, 0, id].pack("CCS>")
		end

		def program id
			@airtower.send! "CPgI", [0, 0, id].pack("CCS>")
		end

	end

end