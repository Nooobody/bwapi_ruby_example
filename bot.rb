$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bwapi_ruby\bwapi_ruby'

class TestBot < Bwapi::Bot
	def on_start
		puts "Game started.."
	end

	def on_frame
		game.draw_text_screen(10, 10, "Playing as #{player.name} - #{player.race}")
	end
end

Bwapi.start_bot(TestBot)
