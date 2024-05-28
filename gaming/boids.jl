WIDTH = 1280
HEIGHT = 720
BACKGROUND = colorant"antiquewhite"

# set number of actors (boids)

n = 200

# select random starting points

x = rand(20:5:(WIDTH - 20), n)
y = rand(20:5:(HEIGHT - 20), n)

# define initial state of actors

r = 2

boid = []

for i ∈ 1:n
    push!(boid, Circle(x[i], y[i], r))
end


# select random colors
colors = [colorant"red", colorant"blue", colorant"green"]

boid_color = []

for i ∈ 1:n
    push!(boid_color, rand(colors))
end

# draw actors

function draw()

    for i ∈ 1:n
        draw(boid[i], boid_color[i], fill = true)
    end
end


# select random initial velocities

range = [collect(-4:-2); collect(2:4)]

vx = rand(range, n)
vy = rand(range, n)

# intial acceleration vectors

ax = zeros(n)
ay = zeros(n)

# create steering force vectors for rules

rx1 = zeros(n)
ry1 = zeros(n)
rx2 = zeros(n)
ry2 = zeros(n)
rx3 = zeros(n)
ry3 = zeros(n)

# define border function

function border(i)
    if boid[i].x > WIDTH
        boid[i].x = 0
    elseif boid[i].x < 0
        boid[i].x = WIDTH
    elseif boid[i].y > HEIGHT
        boid[i].y = 0
    elseif boid[i].y < 0
        boid[i].y = HEIGHT
    end
end


# create distance method

function distance(boid1::Circle, boid2::Circle)
    d = Int(round(sqrt(
        (boid1.x - boid2.x)^2 + (boid1.y - boid2.y)^2

    )))
    return d
end

# set variables for boids

perception_radius = 10
min_speed = 2
max_speed = 4
separation_dial = 60
alignment_dial = 8
cohesion_dial = 100

# define 1 function for all 3 rules

function flock()
    # initialise empty array for separation rules
    separation_force_x = []
    separation_force_y = []

    # initialise empty arrays for alignment rules
    neighbour_vx = []
    neighbour_vy = []

    # initialise empty arrays for cohesion rule
    neighbour_x = []
    neighbour_y = []

    #initialise counter
    total = 0

    for i ∈ 1:n
        for j ∈ 1:n
            # search for boids within perception_radius
            d = distance(boid[i],boid[j])
            if boid[i] !== boid[j] && d < perception_radius
                # populate arrays for separation rule
                if boid[i].x !== boid[j].x
                    s_f_x = boid[i].x - boid[j].x
                else
                    s_f_x = 0
                end
                if boid[i].y !== boid[j].y
                    s_f_y = boid[i].y - boid[j].y
                else
                    s_f_y = 0
                end
                push!(separation_force_x, s_f_x) # distance between neighbouring boids
                push!(separation_force_y, s_f_y)

                # populate arrays for alignment_rule

                push!(neighbour_vx, vx[j])
                push!(neighbour_vy, vy[j])

                # populate arrays for cohesion rule

                push!(neighbour_x, boid[j].x)
                push!(neighbour_y, boid[j].y)

                # increment counter
                total += 1

                # conditional for boids within perception radius
                if total > 0 

                    # 1. Separation rule: steer to avoid crowding local flockmates
                    avg_x1 = Int(round(
                        sum(separation_force_x)/total
                    ))
                    avg_y1 = Int(round(
                        sum(separation_force_y)/total
                    ))

                    steering_force_x1 = Int(round(
                        (avg_x1 - vx[i])/separation_dial
                    ))
                    steering_force_y1 = Int(round(
                        (avg_y1 - vy[i])/separation_dial
                    ))

                    if abs(steering_force_x1) < 1
                        steering_force_x1 = Int(round(
                            min_speed * sign(steering_force_x1)
                        ))
                    end

                    if abs(steering_force_y1) < 1
                        steering_force_y1 = Int(round(
                            min_speed * sign(steering_force_y1)
                        ))
                    end

                    if abs(steering_force_x1) > max_speed
                        steering_force_x1 = Int(round(
                            max_speed * sign(steering_force_x1)
                        ))
                    end

                    if abs(steering_force_y1) > max_speed
                        steering_force_y1 = Int(round(
                            max_speed * sign(steering_force_y1)
                        ))
                    end

                    rx1[i] = steering_force_x1
                    ry1[i] = steering_force_y1

                    # 2. Alignment rule: steer towards the average heading / direction of local flockmates

                    avg_vx = Int(round(
                        sum(neighbour_vx) / total
                    ))
                    avg_vy = Int(round(
                        sum(neighbour_vy) / total
                    ))

                    steering_force_x2 = Int(round(
                        (avg_vx - vx[i]) / alignment_dial
                    ))
                    steering_force_y2 = Int(round(
                        (avg_vy - vy[i]) / alignment_dial
                    ))

                    if abs(steering_force_x2) < 1
                        steering_force_x2 = Int(round(
                            min_speed * sign(steering_force_x2)
                        ))
                    end

                    if abs(steering_force_y2) < 1
                        steering_force_y2 = Int(round(
                            min_speed * sign(steering_force_y2)
                        ))
                    end

                    if abs(steering_force_x2) > max_speed
                        steering_force_x2 = Int(round(
                            max_speed * sign(steering_force_x2)
                        ))
                    end

                    if abs(steering_force_y2) > max_speed
                        steering_force_y2 = Int(round(
                            max_speed * sign(steering_force_y2)
                        ))
                    end

                    rx2[i] = steering_force_x2
                    ry2[i] = steering_force_y2


                    # 3. Cohesion rule: steer to move towards the average position of local flockmates

                    avg_x3 = Int(round(
                        sum(neighbour_x) / total
                    ))
                    avg_y3 = Int(round(
                        sum(neighbour_y) / total
                    ))

                    steering_force_x3 = Int(round(
                        (avg_x3 - boid[i].x - vx[i]) / cohesion_dial
                    ))
                    steering_force_y3 = Int(round(
                        (avg_y3 - boid[i].y - vy[i]) / cohesion_dial
                    ))

                    if abs(steering_force_x3) < 1
                        steering_force_x3 = Int(round(
                            min_speed * sign(steering_force_x3)
                        ))
                    end

                    if abs(steering_force_y3) < 1
                        steering_force_y3 = Int(round(
                            min_speed * sign(steering_force_y3)
                        ))
                    end

                    if abs(steering_force_x3) > max_speed
                        steering_force_x3 = Int(round(
                            max_speed * sign(steering_force_x3)
                        ))
                    end

                    if abs(steering_force_y3) > max_speed
                        steering_force_y3 = Int(round(
                            max_speed * sign(steering_force_y3)
                        ))
                    end

                    rx3[i] = steering_force_x3
                    ry3[i] = steering_force_y3

                end
            end
        end
    end
end

# update position of actors (boids)

function update(g::Game)

    global rx1, rx2, rx3, ry1, ry2, ry3

    flock()

    for i ∈ 1:n
        border(i)

        # calculate accelerations

        ax[i] = rx1[i] + rx2[i] + rx3[i]
        ay[i] = ry1[i] + ry2[i] + ry3[i]

        # update velocities

        vx[i] += ax[i]
        vy[i] += ay[i]

        if vx[i] == 0
            vx[i] = min_speed * rand((-1,1))
        end
        if vy[i] == 0
            vy[i] = min_speed * rand((-1,1))
        end

        if abs(vx[i]) > max_speed
            vx[i] = max_speed * sign(vx[i])
        end
        if abs(vy[i]) > max_speed
            vy[i] = max_speed * sign(vy[i])
        end

        # update positions

        boid[i].x += vx[i]
        boid[i].y += vy[i]

    end

    # clear steering force vectors

    rx1 = zeros(n)
    rx2 = zeros(n)
    rx3 = zeros(n)
    ry1 = zeros(n)
    ry2 = zeros(n)
    ry3 = zeros(n)

end