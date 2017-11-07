module ATEM

	class Switcher

		class Input

			class Audio

				attr_reader :switcher, :input, :id, :type, :media_player, :plug, :mix, :gain, :balance
				attr_accessor :levels

				def self.from packet, switcher, input

					audio = self.new switcher, input
					audio.init_from packet
					audio

				end

				def initialize switcher, input 

					@switcher = switcher
					@input = input
					@level = 0

				end

				def init_from packet 

					@id, @type, @media_player, @plug, @mix, @gain, @balance =
						packet.unpack("S>CxxxCCCxS>s>")

					# Now we have the right data, we can name the input itself
					if @input.quick_init

						values = {
							1001 => ['XLR', 'XLR0'],
							1101 => ['AES/EBU', 'AES3'],
							1201 => ['RCA', 'RCA_'],
						}
						@input.init @input.id, values[@input.id][0], values[@input.id][1] rescue nil

					end

				end

				#####

				def level
					(@levels[:left] + @levels[:right]) / 2
				end

			end

		end

	end

end
