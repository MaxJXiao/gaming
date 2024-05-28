WIDTH = 1280
HEIGHT = 720
BACKGROUND = colorant"antiquewhite"

# number of particles/actors

n = 20
x = rand(20:5:1260, n)
y = rand(20:5:700,n)

# define intial state of actors

r = 20
c = []

for i ∈ 1:n
    push!(c, Circle(x[i], y[i],r))

end

# select random colors for actors
colors = [colorant"red", colorant"green", colorant"blue"]

c_color = []

for i ∈ 1:n
    push!(c_color, rand(colors))
end

# draw actors

function draw(g::Game)
    for i ∈ 1:n
        draw(c[i], c_color[i], fill = true)
    end
end

# random inital velocities

vx = rand((-10, -5 , -1, 1, 5, 10), n)
vy = rand((-10, -5 , -1, 1, 5, 10), n)

# update position of actors

function update(g::Game)
    global vx, vy
    for i ∈ 1:n
        # collision with corners
        if c[i].x < r && c[i].y < r ||
            c[i].x > WIDTH - r && c[i].y < r ||
            c[i].x > WIDTH - r && c[i].y > HEIGHT - r ||
            c[i].x < r && c[i].y > HEIGHT - r
                vx[i] = -vx[i]
                vy[i] = -vy[i]
        #collision with borders
        elseif c[i].x > WIDTH - r || c[i].x < r
            vx[i] = -vx[i]
        elseif c[i].y > HEIGHT - r || c[i].y < r
            vy[i] = -vy[i]
        end
        c[i].x += vx[i]
        c[i].y += vy[i]
    end

    
end