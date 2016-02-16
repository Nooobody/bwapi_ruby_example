$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bwapi_ruby\bwapi_ruby'

class TestBot < Bwapi::Bot
  def on_start
    puts "Game started.."
  end

  def on_frame
    # game.text_size = 10
    game.draw_text_screen(10, 10, "Playing as #{player.name} - #{player.race}")

    units = "My units:\n"

    # iterate through my units
    player.units.each do |unit|
      units << "#{unit.type} #{unit.tile_position}\n"

      # if there's enough minerals, train an SCV
      if unit.type == Bwapi::UnitType.Terran_Command_Center && player.minerals >= 50
        unit.train(Bwapi::UnitType.Terran_SCV)
      end

      # if it's a worker and it's idle, send it to the closest mineral patch
      if unit.type.is_worker && unit.is_idle 
        # find the closest mineral
        minerals = game.neutral.units.select { |u| u.type.is_mineral_field }
        closest_mineral = minerals.sort_by { |m| unit.get_distance(m) }.first
        # if a mineral patch was found, send the drone to gather it
        unit.gather(closest_mineral, false) if closest_mineral
      end
    end

    # draw my units on screen
    game.draw_text_screen(10, 25, units)
  rescue => e
    puts "Caught exception:\n #{e.message} \n#{e.backtrace.join("\n")}---"
  end
end

Bwapi.start_bot(TestBot)
