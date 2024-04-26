class Robot
    def move(direction = nil)
        say "is moving..."
        say "to the #{direction}" if direction
    end
    
    private
    
    def say(something)
        puts ":: #{something}"
    end
end
    
class Roombatrom < Robot
    def move(*args)
        super(*args)
        say "is cleaning..."
    end
end

class RobotIsBroken < StandardError; end
class MartianHouse
    def use(robot)
        begin
            robot.move("moon")
        rescue => e
            raise RobotIsBroken.new(
            "Bad robot: #{e.message}"
        )
        end
    end
end

home = MartianHouse.new
begin
    home.use(Roombatrom.new)
rescue RobotIsBroken => e
    puts "Dirty, dirty floor!"
end

# :: is moving...
# Dirty, dirty floor!