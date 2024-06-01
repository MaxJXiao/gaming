"""
randomwalk()

We walk all the time.
"""
function randomwalk(x::Int,y::Int,n::Int)
    xᵣ = [x]
    yᵣ = [y]
    for i ∈ 1:n
        decision = rand((1,2,3,4))
        if decision == 1
            y += 1
        elseif decision == 2
            x += 1
        elseif decision == 3
            y -= 1
        elseif decision == 4
            x -= 1
        end
        push!(xᵣ, x)
        push!(yᵣ, y)
    end
    return xᵣ,yᵣ
end
function randomwalk(v::Vector{Int64},n::Int)
    x = v[1]
    y = v[2]
    xᵣ = [x]
    yᵣ = [y]
    for i ∈ 1:n
        decision = rand((1,2,3,4))
        if decision == 1
            y += 1
        elseif decision == 2
            x += 1
        elseif decision == 3
            y -= 1
        elseif decision == 4
            x -= 1
        end
        push!(xᵣ, x)
        push!(yᵣ, y)
    end
    return xᵣ,yᵣ
end
function randomwalk(n::Int)
    x = 0
    y = 0
    xᵣ = [x]
    yᵣ = [y]
    for i ∈ 1:n
        decision = rand((1,2,3,4))
        if decision == 1
            y += 1
        elseif decision == 2
            x += 1
        elseif decision == 3
            y -= 1
        elseif decision == 4
            x -= 1
        end
        push!(xᵣ, x)
        push!(yᵣ, y)
    end
    return xᵣ,yᵣ
end


"""
modernart()

wow
"""
function modernart(pl,t::Tuple{Vector{Int64}, Vector{Int64}}, c)
    plot!(pl,t,
    color = c,
    )
    return pl
end
function modernart(t::Tuple{Vector{Int64}, Vector{Int64}}, c)
    pl = plot(t,
    color = c,
    legend = false,
    showaxis = false,
    grid = false
    )
    return pl
end
function modernart(pl,t::Tuple{Vector{Int64}, Vector{Int64}})
    plot!(pl,t,
    color = RGB(rand(color_v),rand(color_v),rand(color_v)),
    )
    return pl
end
function modernart(t::Tuple{Vector{Int64}, Vector{Int64}})
    pl = plot(t,
    color = RGB(rand(color_v),rand(color_v),rand(color_v)),
    showaxis = false,
    grid = false,
    legend = false,
    )
    return pl
end
function modernart(walkers::Int,steps::Int)
    pl = plot(randomwalk(steps),
    color = RGB(rand(color_v),rand(color_v),rand(color_v)),
    showaxis = false,
    grid = false,
    legend = false,
    )
    for i ∈ 1:(walkers-1)
        plot!(pl, randomwalk(steps),
        color = RGB(rand(color_v),rand(color_v),rand(color_v))
        )
    end


    return pl
end
function modernart(pl, walkers::Int,steps::Int)
    for i ∈ 1:walkers
        plot!(pl, randomwalk(steps),
        color = RGB(rand(color_v),rand(color_v),rand(color_v))
        )
    end
    return pl
end
color_v = 0.00:0.01:1.00

kevin = modernart(10,100000)

# savefig(kevin,"kevinwalksallthetime.png")



# testing = modernart(50,1000)

# testing

# modernart(testing,50,1000)

# modernart(10,10000)




# test = modernart(randomwalk(50))


# modernart(test,randomwalk(50))

# plot(randomwalk(20), color = RGB(rand(color_v),rand(color_v),rand(color_v)),

# showaxis = false,
# grid = false
# )


# ## gr(size = (600,600))
# using Plots
# x,y = rand(1:10, 10), rand(1:10, 10)
# plot(x, y;  legend = false)

# k = plot(randomwalk(10)
# )

# plot!(k, randomwalk(20), color = RGB(rand(color_v),rand(color_v),rand(color_v)))

# k

# color_v = 0.00:0.01:1.00