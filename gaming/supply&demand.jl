## Supply Curve
# Q(P) = 3P - 6
# Hence, 

P_supply(Q) = (Q + 6)/3

## Demand Curve
# Q(P) = 32 - 2P

P_demand(Q) = (32 - Q) / 2


using CairoMakie
CairoMakie.activate!()

## initialise empty scene and layout

scene, layout = layoutscene(resolution = (500,500))

scene

## add axis

ax = layout[1,1] = Axis(scene,
    xlabel = "Quantity", xlabelsize = 10, xticklabelsize = 9, xticksize = 3,
    ylabel = "Price", ylabelsize = 10, yticklabelsize = 9, yticksize = 3,
    ytickformat = "\${:d}", #{:d} should be displayed as integers
    title = "Supply and Demand", titlesize = 12
)

scene


Q_range = 1:25

lineobject1 = lines!(ax, Q_range, P_supply, linewidth = 1, color = :blue)
lineobject2 = lines!(ax, Q_range, P_demand, linedwith = 1, color = :red)

leg = Legend(scene, [lineobject1, lineobject2],
    ["Supply", "Demand"], halign = :right, valign = :top,
    tellheight = false, tellwidth = false, margin = (10,10,10,10),
    labelsize = 7, linewidth = 1, padding = (10,10,5,5),
    patchsize = (20,10)
)
layout[1,1] = leg

scene

## reconfigure supply and demand curve to match Ax + b format

"""
Q(P) = 3P - 6
Q(P) = 32 - 2P

Q - 3P = -6
Q + 2P = 32

[1 -3 | -6]
[1  2 | 32]
"""

A = [1 -3; 1 2]
b = [-6, 32]

e_Q, e_P = A \ b

println("Equilibrium Price:\t", e_P)
println("Equilibrium Quantity:\t", e_Q)

vlines!(ax, [e_Q], ymax = [0.411], # 0.411 how far away from axis it goes
    linewidth = 1, linestyle = :dash, color = :green
)
hlines!(ax, [e_P], xmax = [0.645],
    linewidth = 1, linestyle = :dash, color = :green
)

scene

save("supply-demand.svg",scene)



################## Mortgage calculator

function pmt(r,N,P)
    c = r*P /(1 - (1 + r)^(-N))
end

# 3.92% interest rate, $100000 mortgage amount, over 30 years


r = 3.92 / 100 / 12 # convert into decimal then into monthly
N = 30 * 12 # years to months
P = 100000

c = pmt(r,N,P)

total = c*N

function pmt_table(APR, years, amount)
    # initialise variables
    r = APR / 100 / 12
    N = years * 12
    P = amount
    c = pmt(r,N,P)
    # B, A, S, E, Beginning Balance, add, subtract, end Balance

    B = P           # beginning balance
    A = r*B         # add monthly interest charge
    S = c           # subtract monthly interst payment
    E = P + A - S   # ending balance

    data = [B,A,S,E]

    for i ∈ 1:(N - 1)
        B = E
        A = r*B
        S = c
        E = B + A - S
        push!(data, B,A,S,E)

    end    
    # reshape to column vector
    wide = reshape(data,4,N)
    tall = transpose(wide)
    # convert tall table into Array

    tallarray = Array(tall)
    return tallarray
end


# initialise variables

APR = 3.92
years = 30
amount = 100000

data = pmt_table(APR, years, amount)

vscodedisplay(data)

using DelimitedFiles
writedlm("pmt_table.csv", data, ',')


# prep data for plotting


interest = data[:,2]
payment = data[:,3]

p_pmt = payment - interest # calculate principal payments

using CairoMakie


scene, layout = layoutscene(resolution = (750,325))
scene

# add first axis 

ax1 = layout[1,1] = Axis(scene,
    xlabel = "Months", xlabelsize = 10, xticklabelsize = 9, xticksize = 3,
    ylabel = "Dollars", ylabelsize = 10, yticklabelsize = 9, yticksize = 3,
    ytickformat = "\${:d}",
    title = "Monthly Payments", titlesize = 12


)
scene

lineobject1 = lines!(ax1, p_pmt, linewidth = 1, color = :blue)
lineobject2 = lines!(ax1, interest, linewidth = 1, color = :red)
lineobject3 = lines!(ax1, payment, linewidth = 1, color = :green)


leg1 = Legend(scene, [lineobject1, lineobject2, lineobject3],
    ["Principal", "Interest", "Total Pmt"], halign = :right, valign = :center,
    tellheight = false, tellwidth = false, margin = (10,10,10,10),
    labelsize = 5, linewidth = 1, padding = (10,10,5,5),
    patchsize = (15,10)
)
layout[1,1] = leg1

scene

# total principal payment total
function total_p_pmt(p_pmt)
    runningtotal = p_pmt[1]
    data = [runningtotal]
    for i ∈ 2:length(p_pmt)
        runningtotal = runningtotal + p_pmt[i]
        push!(data, runningtotal)
    end

    return data
end

p_pmtsum = total_p_pmt(p_pmt)
vscodedisplay(p_pmtsum)

# cumulative interest payments 

function total_int(interest)
    runningtotal = interest[1]
    data = [runningtotal]
    for i ∈ 2:length(interest)
        runningtotal = runningtotal + interest[i]
        push!(data, runningtotal)
    end
    return data
end


intsum = total_int(interest)
vscodedisplay(intsum)


# add second axis 

ax2 = layout[1,2] = Axis(scene,
    xlabel = "Months", xlabelsize = 10, xticklabelsize = 9, xticksize = 3,
    yticklabelsize = 7, yticksize = 3,
    ytickformat = "\${:d}",
    title = "Cumulative Payments", titlesize = 12


)

scene

lineobject1 = lines!(ax2, p_pmtsum, linewidth = 1, color = :blue)
lineobject2 = lines!(ax2, intsum, linewidth = 1, color = :red)

leg2 = Legend(scene, [lineobject1, lineobject2],
    ["Principal", "Interest"], halign = :center, valign = :top,
    tellheight = false, tellwidth = false, margin = (10,10,10,10),
    labelsize = 5, linewidth = 1, padding = (10,10,5,5),
    patchsize = (15,5)
)
layout[1,2] = leg2

scene

save("mortgage-calculator.svg", scene)