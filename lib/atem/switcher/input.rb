module ATEM

	class Switcher

		class Input

			attr_reader :switcher, :id, :name, :short_name, :quick_init
			attr_accessor :type, :audio

			module Type
				VIDEO = 0x01
				AUDIO = 0x02
				AUDIO_VIDEO = 0x03
			end

			def self.from packet, switcher, type

				input = self.new switcher
				input.init_from packet

				input.type = type

				input

			end

			def initialize switcher

				@switcher = switcher

			end

			def init_from packet 

				@id, @name, @short_name, @supported, @ext_port_type, @port_type, @availability = 
					packet.unpack("S>Z20Z4xCxCCxC")

			end

			def init id, name = nil, short_name = nil

				@id = id
				@name = name or "Input #{@id}"
				@short_name = short_name or "#{@id.to_s.rjust(4, "0")}"
				@quick_init = true

			end

			######

			def preview
				@switcher.preview @id
			end

			def program
				@switcher.program @id
			end

		end

	end

end