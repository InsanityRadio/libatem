require_relative 'atem/network'
require_relative 'atem/switcher'
require_relative 'atem/switcher/input'
require_relative 'atem/switcher/input_collection'

module ATEM

	def self.connect ip, port = 9910

		s = Switcher.new({ :ip => ip, :port => port, :uid => 0x1337 })
		s.connect

		s

	end

end