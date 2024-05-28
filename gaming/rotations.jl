WIDTH = 1280
HEIGHT = 720
BACKGROUND = colorant"antiquewhite"


# define initial state of actors

hline = Line(0, HEIGHT / 2, WIDTH, HEIGHT / 2)
vline = Line(WIDTH / 2, 0, WIDTH / 2, HEIGHT)

r_orbit = 200
r_planet = 20

x = WIDTH / 2 + r_orbit
y = HEIGHT / 2

orbit = Circle(WIDTH / 2, HEIGHT / 2, r_orbit)
planet = Circle(x, y, r_planet)

# draw actors

function draw(g::Game)
    draw(hline, colorant"black")
    draw(vline, colorant"black")
    draw(orbit, colorant"black", fill = false)
    draw(planet, colorant"blue", fill = true)
end


# set values for theta and speed

θ = 0 
speed = 2

# rotate actor clockwise in Circle

# function update(g::Game)
#     global θ
#     θ += speed
#     planet.x = Int(round(cosd(θ) * r_orbit + WIDTH/2))
#     planet.y = Int(round(sind(θ) * r_orbit + HEIGHT/2))
# end


# rotate actor clockwise in Ellipse

function update(g::Game)
    global θ
    θ += speed
    planet.x = Int(round(cosd(θ) * r_orbit * 2 + WIDTH/2))
    planet.y = Int(round(sind(θ) * r_orbit + HEIGHT/2))
end

