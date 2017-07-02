#!/bin/env ruby


$AUDIO_THRESHOLD = 858803
$IP = "10.32.0.119"

require_relative '../lib/atem'

class VisionMixer

	attr_accessor :close, :wide

	def initialize ip, close, wide, slate

		@ip = ip
		@close = close
		@wide = wide
		@current_camera = wide[0]

		connect!

		@close.map! { | w | @atem.inputs[w] }
		@wide.map! { | w | @atem.inputs[w] }

		@slate = @atem.inputs[slate]

		sleep 5
		loop do

			select_camera
			sleep 2
			# Make the camera live then start immediately gathering data again
			live_camera
			reset_peaks
			sleep 5

		end

	end

	def connect!

		@atem = ATEM.connect(@ip)
		@atem.use_audio_levels = true
		@atem.inputs[@current_camera].program

	end

	def select_camera

		begin

			if @break

				@new_camera = @slate
				raise "Done"

			end
			
			if @wide.include? @current_camera

				if Random.rand(3) == 0
					@new_camera = @wide.sample
					raise "Done"
				end

				highest = [nil, $AUDIO_THRESHOLD]
				@close.each do | cam |

					highest = [cam, cam.audio.levels[:peak_left]] if cam.audio.levels[:peak_left] > highest[1]

				end

				if highest != nil

					@new_camera = highest[0]
					raise "Done"

				end

			end

			if @close.include? @current_camera

				if Random.rand(3) == 0
					@new_camera = @wide.sample
					raise "Done"
				end

				@new_camera = @close.sample
				raise "Done"

			end

			@new_camera = @wide.sample

		rescue
		end

		debug "Selected camera #{@new_camera.name}"

		@new_camera.preview

	end

	def live_camera

		debug "#{@new_camera.name} is live"

		@new_camera.program
		@current_camera = @new_camera

	end

	def reset_peaks

		@atem.reset_audio_peaks

	end

	private
	def info message

		puts "[ INFO ]  #{message}"

	end

	def debug message

		puts "[ DEBUG ] #{message}" if $debug

	end

end

$debug = true
VisionMixer.new $IP, ['Pres', 'Gst'], ['Wide'], 'MP1'

