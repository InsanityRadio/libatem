module ATEM

	class Switcher

		class InputCollection

			attr_reader :switcher

			def initialize switcher
				@switcher = switcher
				@inputs = {}
			end

			def add input

				@inputs[input.id] = input

			end

			def [] index

				return @inputs[index] if @inputs[index]

				@inputs.each do | a, input |

					return input if input.name == index or input.short_name.downcase == index.downcase

				end

			end

		end

	end

end