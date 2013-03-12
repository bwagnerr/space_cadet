require 'gosu'
require './player'
require './star'
require './zorder'

class GameWindow < Gosu::Window

	def initialize
    @width = 1600;
    @height = 900;
    super(@width, @height, false)
    self.caption = "Try"

    @background_image = Gosu::Image.new(self, "img/wall.jpg", true)
    @title_screen = Gosu::Image.new(self, "img/title_screen.png", true)
    @btn_launch_screen = Gosu::Image.new(self, "img/launch.png", true)

    @start = false

    @player = Player.new(self)
    @player.warp(@width/2, @height/2)

    @star_anim = Gosu::Image::load_tiles(self, "img/asteroid.png", 100, 100, false)
    @stars = Array.new

    @lose_font = Gosu::Font.new(self, Gosu::default_font_name, 380)
    @score_font = Gosu::Font.new(self, Gosu::default_font_name, 30)
    @timer_start = Time.now
    @timer = 0
  end

  def needs_cursor?
    true
  end

  def update
    if button_down? Gosu::MsLeft
      if @draw_button_x and @draw_button_y
        button_hover = Gosu::distance(@draw_button_x, @draw_button_y, mouse_x, mouse_y)
        @start = true if(button_hover < 200)
      end
    end
    return nil if !@start
    return nil if @player.lost?
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)
    @timer = "%.2f" % (Time.now - @timer_start).to_f
    if rand(100) < 4 
      @stars.push(Star.new(@star_anim, @height,@width))
    end
  end

  def draw
    if !@start and (@player and !@player.lost?)
      @title_screen.draw(0, 0, ZOrder::Background)
      @draw_button_x = @width/2-218
      @draw_button_y = @height-280
      @btn_launch_screen.draw(@draw_button_x,@draw_button_y , 99, 0.75,0.75)
      @score_font.draw_rel('Starcraft III',@width/2,150,1,0.5,0.5)
    else
      @background_image.draw(0, 0, ZOrder::Background)
      @player.draw
      @stars.each { |star| star.draw }

      @score_font.draw_rel('Score: ',0,0,1,0,0)
      @score_font.draw_rel("#{@timer} secs",90,0,1,0,0)
      
      @lose_font.draw_rel('YOU LOSE!',@width/2,@height/2,1,0.5,0.5) if @player.lost?
    end 
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end
end

window = GameWindow.new
window.show
