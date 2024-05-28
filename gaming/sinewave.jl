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


hline_upper = Line(0, HEIGHT / 2 + r_orbit,
    WIDTH, HEIGHT / 2 + r_orbit)
hline_lower = Line(0, HEIGHT / 2 - r_orbit,
    WIDTH, HEIGHT / 2 - r_orbit)

# define intitial state of wave actors

r_wave = 10
n_wave = 2

len = Int(round(WIDTH / (r_wave * n_wave))) + 1
angles = []

for i ∈ 0:(len-1)
    θ = Int(round(360 / (len - 1) * i * n_wave))
    push!(angles, θ)
end

x_wave = []

for i ∈ 1:len
    x_i = Int(round(WIDTH / (len - 1) * i)) - r_wave * n_wave
    push!(x_wave, x_i)
end

y_wave = []

for i ∈ 1:len
    y_i = Int(round(sind(angles[i]) * r_orbit + HEIGHT / 2))
    push!(y_wave, y_i)
end

wave = []

for i ∈ 1:len
    push!(wave, Circle(x_wave[i], y_wave[i], r_wave))
end

# draw actors

function draw(g::Game)
    # guidelines

    draw(hline, colorant"black")
    draw(vline, colorant"black")
    draw(hline_upper, colorant"black")
    draw(hline_lower, colorant"black")

    # planet
    
    draw(orbit, colorant"black", fill = false)
    draw(planet, colorant"blue", fill = true)

    for i ∈ 1:len
        draw(wave[i], colorant"red", fill = true)
    end
end

# set values for theta and speed 

θ = 0
speed = 2

# rotate planet clockwise in Circle

function update_planet()

    global θ
    θ += speed
    planet.x = Int(round(cosd(θ) * r_orbit + WIDTH / 2))
    planet.y = Int(round(sind(θ) * r_orbit + HEIGHT / 2))

end

# update sine_wave

function update_wave()
    global angles
    for i ∈ 1:len
        angles[i] += speed
        wave[i].y = Int(round(sind(angles[i]) * r_orbit + HEIGHT / 2 ))
    end
end


# update game window

function update(g::Game)
    update_planet()
    update_wave()
end