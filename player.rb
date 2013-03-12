class Player

	def initialize(window)
		@image = Gosu::Image.new(window, "img/ship.gif",false)
		@x = @y = @vel_x = @vel_y = @angle = 0.0
		@score = 0	
	end

	def warp(x, y)
		@x, @y = x,y
	end

	def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.3)
    @vel_y += Gosu::offset_y(@angle, 0.3)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 1600
    @y %= 900
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle, 0.5,0.5,0.25,0.25)
  end

  def score
    @score
  end

  def lost?
    @lost
  end

  def collect_stars(stars)
    stars.each  do |star|
      @lost = true if Gosu::distance(@x, @y, star.x, star.y) < 70
    end
    # if stars.reject! {|star| Gosu::distance(@x, @y, star.x, star.y) < 70 } then
    #   @lost = true
    #   #@score += 1
    # end
  end
end
