class Particle < Gosu::image

  def initialize x,y,velX,velY,window,path,tileable
    super(window,path,tileable)
    @x = x
    @y = y
    @velx = velX
    @velY = velY
  end

  def update diffTime
    @x+=  @x*@velx *(diffTime/1000.0)
    @y+=  @y*@vely *(diffTime/1000.0)

  end

  def setDirection velX velY
    @velX = velX
    @velY = velY
  end
end