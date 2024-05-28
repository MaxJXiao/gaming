WIDTH = 1280
HEIGHT = 720
BACKGROUND = colorant"antiquewhite"


# define initial state of actors

hline = Line(0, HEIGHT / 2, WIDTH, HEIGHT / 2)
vline = Line(WIDTH / 2, 0, WIDTH / 2, HEIGHT)

r_orbit = 200

orbit = Circle(WIDTH / 2, HEIGHT / 2, r_orbit)

# define pendulum

r_bob = 20
l_rod = 200

θ = 120

x_bob = Int(round(sind(θ) * l_rod + WIDTH / 2))
y_bob = Int(round(cosd(θ) * l_rod + HEIGHT / 2))


rod = Line(WIDTH / 2, HEIGHT / 2, x_bob, y_bob)
bob = Circle(x_bob, y_bob, r_bob)

# draw actors

function draw(g::Game)
    # guidelines
    draw(hline, colorant"black")
    draw(vline, colorant"black")
    draw(orbit, colorant"black", fill = false)
    # pendulum
    draw(rod, colorant"blue")
    draw(bob, colorant"blue", fill = true)
end

# set values for gravity and angular velocity

gravity = 10 
ang_vel = 0


# pendulum motion without friction

# function update(g::Game)
#     global ang_vel, θ
#     # calculate new theta

#     tangential_force = -gravity * sind(θ)
#     ang_acc = tangential_force / l_rod
#     ang_vel += ang_acc
#     θ += ang_vel
#     # calculate new (x,y)

#     bob.x = rod.x2 = Int(round(sind(θ) * l_rod + WIDTH / 2))
#     bob.y = rod.y2 = Int(round(cosd(θ) * l_rod + HEIGHT / 2))
# end


friction = 0.999


# pendulum motion with friction

function update(g::Game)
    global ang_vel, θ
    # calculate new theta

    tangential_force = -gravity * sind(θ)
    ang_acc = tangential_force / l_rod
    ang_vel += ang_acc
    ang_vel *= friction
    θ += ang_vel
    # calculate new (x,y)

    bob.x = rod.x2 = Int(round(sind(θ) * l_rod + WIDTH / 2))
    bob.y = rod.y2 = Int(round(cosd(θ) * l_rod + HEIGHT / 2))
end

