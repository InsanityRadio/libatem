module ATEM

	class Switcher

		class Input

			attr_reader :switcher, :id, :name, :short_name

			def self.from packet, switcher

				input = self.new switcher
				input.init_from packet

				input

			end

			def initialize switcher

				@switcher = switcher

			end

			def init_from packet 

				@id, @name, @short_name, @supported, @ext_port_type, @port_type, @availability = 
					packet.unpack("S>a20a4xCxCCxC")

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