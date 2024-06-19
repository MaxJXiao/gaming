using BenchmarkTools
using FileIO
using JLD2

board = [0 0 0 0 0 0 0 0 0]

q = [100 100 100 100 100 100 100 100 100 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]
α = 1
β = 0.01


test_board = [1 0 0 -1 0 0 1 0 0]


function normalise(v)
    l = length(v)
    sum_square = 0
    for i ∈ 1:l 
        sum_square += v[i]^2
    end

    return v./sqrt(sum_square)
    
end

function r_board()
    board .= 0
end

function screen(board)
    check = 0
    for i ∈ board
        if i != 0
            check += 1
        end
    end
    return check
end

function board_state(board)
    if abs(board[1] + board[2] + board[3]) == 3 
        return 1
    elseif abs(board[4] + board[5] + board[6]) == 3 
        return 1
    elseif abs(board[7] + board[8] + board[9]) == 3 
        return 1
    elseif abs(board[1] + board[4] + board[7]) == 3 
        return 1
    elseif abs(board[2] + board[5] + board[8]) == 3 
        return 1
    elseif abs(board[3] + board[6] + board[9]) == 3 
        return 1
    elseif abs(board[1] + board[5] + board[9]) == 3 
        return 1
    elseif abs(board[3] + board[5] + board[7]) == 3 
        return 1
    end

    if screen(board) == 9
        return 0
    else
        return -200
    end

end


function q_vecgen(num)
    q_vecs = []
    for i ∈ 1:num
        q_vec = [100 100 100 100 100 100 100 100 100 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]

        q_state(q_vec, α, β)
        append!(q_vecs, [q_vec])
    end
    return q_vecs
end
function q_vecgen(vec, num)
    q_vecs = [vec]
    for i ∈ 1:(num-1)
        q_vec = vec

        q_state(q_vec, α, β)
        append!(q_vecs, [q_vec])
    end
    return q_vecs
end



function q_state(q_state, α, β)
    for i ∈ 1:9
        q_state[i] += α*randn()
    end
    for i ∈ 10:18
        q_state[i] += β*randn()
    end
end

function evaluation(board, q_state, turn)
    eval_pos = 0
    eval_neg = 0
    for i ∈ 1:9
        if board[i] == 1
            eval_pos += q_state[i]
        elseif board[i] == -1
            eval_neg += q_state[i]
        end
    end

    r_wards = rewards(board, q_state)

    eval_pos *= 1 + r_wards[1]
    eval_neg *= 1 + r_wards[2]

    if turn % 2 == 1
        eval_pos *= 2/(turn - 1 + 0.001)
        eval_neg *= 2/(turn - 1 + 0.001)
    elseif turn % 2 == 0
        eval_pos *= 2/turn
        eval_neg *= 2/(turn - 2 + 0.001)
    end



    return [eval_pos, eval_neg]
    
    

end


function future_evaluation(board, q_state, turn)

    i_future = []
    r_future = []


    for i ∈ 1:9

        mod_board = copy(board)

        if mod_board[i] == 0 && board_state(board) == -200
            if turn % 2 == 1
                mod_board[i] = 1
                if board_state(mod_board) == 1
                    append!(i_future, [[i]])
                    append!(r_future, [[100, 0]])
                elseif board_state(mod_board) == 0
                    append!(i_future, [[i]])
                    append!(r_future, [[0,0]])
                else
                    for j ∈ 1:9

                        copy_board = copy(mod_board)

                        if copy_board[j] == 0
                            copy_board[j] = -1

                            if board_state(copy_board) == 1
                                append!(i_future, [[i]])
                                append!(r_future, [[0, 100]])
                            elseif board_state(copy_board) == 0
                                append!(i_future, [[i]])
                                append!(r_future, [[0, 0]])
                            else
                                append!(i_future, [[i]])
                                append!(r_future, [evaluation(copy_board, q_state, turn + 2)])
                            end
                        end
                    end
                end

            elseif turn % 2 == 0
                mod_board[i] = -1
                if board_state(mod_board) == 1
                    append!(i_future, [[i]])
                    append!(r_future, [[0, 100]])
                elseif board_state(mod_board) == 0
                    append!(i_future, [[i]])
                    append!(r_future, [[0,0]])
                else
                    for j ∈ 1:9

                        copy_board = copy(mod_board)

                        if copy_board[j] == 0
                            copy_board[j] = 1

                            if board_state(copy_board) == 1
                                append!(i_future, [[i]])
                                append!(r_future, [[100, 0]])
                            elseif board_state(copy_board) == 0
                                append!(i_future, [[i]])
                                append!(r_future, [[0, 0]])
                            else
                                append!(i_future, [[i]])
                                append!(r_future, [evaluation(copy_board, q_state, turn + 2)])
                            end
                        end
                    end
                end
            end

        end

    end


    return i_future, r_future
    
    

end


function choices(board, q_state, turn)

    ind, rewards = future_evaluation(board, q_state, turn)
    l = length(ind)

    uniq_ind = unique(ind)
    u = length(uniq_ind)


    diff = []

    for i ∈ 1:l 
        append!(diff, rewards[i][1] - rewards[i][2])
    end

    eval = []

    for i ∈ 1:u 
        min_max = []
        for j ∈ 1:l 

            if uniq_ind[i] == ind[j]
                append!(min_max, diff[j])
            end

        end

        if turn % 2 == 1
            append!(eval, min(min_max...))
        elseif turn % 2 == 0
            append!(eval, max(min_max...))
        end
    end


    if turn % 2 == 1
        choice = uniq_ind[findmax(eval)[2]]
        return choice, uniq_ind, eval
    elseif turn % 2 == 0
        choice = uniq_ind[findmin(eval)[2]]
        return choice, uniq_ind, eval
    end

    
end


function decision(board, q_state, turn, prob)
    x = rand()
    opt = choices(board, q_state, turn)
    if x < prob
        return opt[1]
    else
        return rand(opt[2])
    end
end


function rewards(board, q_state)
    
    r_pos = 0
    r_neg = 0

    r_pos += rewarding(board, q_state, [1,2,3], 1)
    r_neg += rewarding(board, q_state, [1,2,3], -1)

    r_pos += rewarding(board, q_state, [1,3,2], 1)
    r_neg += rewarding(board, q_state, [1,3,2], -1)

    r_pos += rewarding(board, q_state, [2,3,1], 1)
    r_neg += rewarding(board, q_state, [2,3,1], -1)

    r_pos += rewarding(board, q_state, [4,5,6], 1)
    r_neg += rewarding(board, q_state, [4,5,6], -1)

    r_pos += rewarding(board, q_state, [4,6,5], 1)
    r_neg += rewarding(board, q_state, [4,6,5], -1)

    r_pos += rewarding(board, q_state, [5,6,4], 1)
    r_neg += rewarding(board, q_state, [5,6,4], -1)

    r_pos += rewarding(board, q_state, [7,8,9], 1)
    r_neg += rewarding(board, q_state, [7,8,9], -1)

    r_pos += rewarding(board, q_state, [7,9,8], 1)
    r_neg += rewarding(board, q_state, [7,9,8], -1)

    r_pos += rewarding(board, q_state, [8,9,7], 1)
    r_neg += rewarding(board, q_state, [8,9,6], -1)



    r_pos += rewarding(board, q_state, [1,4,7], 1)
    r_neg += rewarding(board, q_state, [1,4,7], -1)

    r_pos += rewarding(board, q_state, [1,7,4], 1)
    r_neg += rewarding(board, q_state, [1,7,4], -1)

    r_pos += rewarding(board, q_state, [4,7,1], 1)
    r_neg += rewarding(board, q_state, [4,7,1], -1)

    r_pos += rewarding(board, q_state, [2,5,8], 1)
    r_neg += rewarding(board, q_state, [2,5,8], -1)

    r_pos += rewarding(board, q_state, [2,8,5], 1)
    r_neg += rewarding(board, q_state, [2,8,5], -1)

    r_pos += rewarding(board, q_state, [5,8,2], 1)
    r_neg += rewarding(board, q_state, [5,8,2], -1)

    r_pos += rewarding(board, q_state, [3,6,9], 1)
    r_neg += rewarding(board, q_state, [3,6,9], -1)

    r_pos += rewarding(board, q_state, [3,9,6], 1)
    r_neg += rewarding(board, q_state, [3,9,6], -1)

    r_pos += rewarding(board, q_state, [6,9,3], 1)
    r_neg += rewarding(board, q_state, [6,9,3], -1)



    r_pos += rewarding(board, q_state, [1,5,8], 1)
    r_neg += rewarding(board, q_state, [1,5,8], -1)

    r_pos += rewarding(board, q_state, [1,9,5], 1)
    r_neg += rewarding(board, q_state, [1,9,5], -1)

    r_pos += rewarding(board, q_state, [5,9,1], 1)
    r_neg += rewarding(board, q_state, [5,9,1], -1)

    r_pos += rewarding(board, q_state, [3,5,7], 1)
    r_neg += rewarding(board, q_state, [3,5,7], -1)

    r_pos += rewarding(board, q_state, [3,7,5], 1)
    r_neg += rewarding(board, q_state, [3,7,5], -1)

    r_pos += rewarding(board, q_state, [5,7,3], 1)
    r_neg += rewarding(board, q_state, [5,7,3], -1)

    return [r_pos, r_neg]


end


function rewarding(board, q_state, combos, parity)
    if board[combos[1]] == board[combos[2]] &&
        board[combos[1]] == parity && board[combos[3]] != -1*parity
            return q_state[9 + combos[1]] + q_state[9 + combos[2]]
    else
        return 0
    end
end






function runtictac(runs, q₁, q₂)

    wins = [0.0 0.0]
    boards = []

    for j ∈ 1:runs

        r_board()


        if j % 2 == 1

            for i ∈ 1:9


                if i % 2 == 1
                    xuanze = decision(board, q₁, i, 0.9)
                    board[xuanze[1]] = 1
                elseif i % 2 == 0
                    xuanze = decision(board, q₂, i, 0.9)
                    board[xuanze[1]] = -1
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        println("$i win")
                        wins[1] += 1

                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    elseif i % 2 == 0
                        println("$i win")
                        wins[2] += 1
                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    end
                elseif board_state(board) == 0

                    println("draw")
                    wins[1] += 0.5
                    wins[2] += 0.5
                    copying = copy(board)
                    append!(boards, [copying])
                    break

                end

            end


        elseif j % 2 == 0

            for i ∈ 1:9


                if i % 2 == 1
                    xuanze = decision(board, q₂, i, 0.9)
                    board[xuanze[1]] = 1
                elseif i % 2 == 0
                    xuanze = decision(board, q₁, i, 0.9)
                    board[xuanze[1]] = -1
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        println("$i win")
                        wins[2] += 1
                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    elseif i % 2 == 0
                        println("$i win")
                        wins[1] += 1
                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    end
                elseif board_state(board) == 0

                    println("draw")
                    wins[1] += 0.5
                    wins[2] += 0.5
                    copying = copy(board)
                    append!(boards, [copying])
                    break

                end

            end

        end


    end

    return wins, boards

end

function rand_xuan(board, turn)
    ind = []
    for i ∈ 1:9
        if board[i] == 0
            append!(ind, i)
        end
    end

    if turn % 2 == 1
        board[rand(ind)] = 1
    elseif turn % 2 == 0
        board[rand(ind)] = -1
    end
end


function runrandtic(runs, q)

    wins = [0.0 0.0]
    boards = []

    for j ∈ 1:runs

        r_board()


        if j % 2 == 1

            for i ∈ 1:9


                if i % 2 == 1
                    xuanze = decision(board, q, i, 1)
                    board[xuanze[1]] = 1
                elseif i % 2 == 0
                    rand_xuan(board, i)
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        println("q win")
                        wins[1] += 1

                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    elseif i % 2 == 0
                        println("rand win")
                        wins[2] += 1
                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    end
                elseif board_state(board) == 0

                    println("draw")
                    wins[1] += 0.5
                    wins[2] += 0.5
                    copying = copy(board)
                    append!(boards, [copying])
                    break

                end

            end


        elseif j % 2 == 0

            for i ∈ 1:9


                if i % 2 == 1
                    rand_xuan(board, i)
                elseif i % 2 == 0
                    xuanze = decision(board, q, i, 1)
                    board[xuanze[1]] = -1
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        println("rand win")
                        wins[2] += 1
                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    elseif i % 2 == 0
                        println("q win")
                        wins[1] += 1
                        copying = copy(board)
                        append!(boards, [copying])
                        break
                    end
                elseif board_state(board) == 0

                    println("draw")
                    wins[1] += 0.5
                    wins[2] += 0.5
                    copying = copy(board)
                    append!(boards, [copying])
                    break

                end

            end

        end


    end

    return wins, boards

end



function runstream(runs, q₁, q₂)

    wins = [0.0 0.0]
    #boards = []

    for j ∈ 1:runs

        r_board()


        if j % 2 == 1

            for i ∈ 1:9


                if i % 2 == 1
                    xuanze = decision(board, q₁, i, 0.9)
                    board[xuanze[1]] = 1
                elseif i % 2 == 0
                    xuanze = decision(board, q₂, i, 0.9)
                    board[xuanze[1]] = -1
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        #println("$i win")
                        wins[1] += 1

                        #copying = copy(board)
                        #append!(boards, [copying])
                        break
                    elseif i % 2 == 0
                        #println("$i win")
                        wins[2] += 1
                        #copying = copy(board)
                        #append!(boards, [copying])
                        break
                    end
                elseif board_state(board) == 0

                    #println("draw")
                    wins[1] += 0.5
                    wins[2] += 0.5
                    #copying = copy(board)
                    #append!(boards, [copying])
                    break

                end

            end


        elseif j % 2 == 0

            for i ∈ 1:9


                if i % 2 == 1
                    xuanze = decision(board, q₂, i, 0.9)
                    board[xuanze[1]] = 1
                elseif i % 2 == 0
                    xuanze = decision(board, q₁, i, 0.9)
                    board[xuanze[1]] = -1
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        #println("$i win")
                        wins[2] += 1
                        #copying = copy(board)
                        #append!(boards, [copying])
                        break
                    elseif i % 2 == 0
                        #println("$i win")
                        wins[1] += 1
                        #copying = copy(board)
                        #append!(boards, [copying])
                        break
                    end
                elseif board_state(board) == 0

                    #println("draw")
                    wins[1] += 0.5
                    wins[2] += 0.5
                    #copying = copy(board)
                    #append!(boards, [copying])
                    break

                end

            end

        end


    end

    return wins

end


function running_qs(block, battles)
    l = length(block)
    win_share = zeros(l, l)

    for i ∈ 1:l 
        for j ∈ 1:l 
            if i != j && win_share[i,j] == 0
                i_share, j_share = runstream(battles, block[i], block[j])
                win_share[i, j] = i_share
                win_share[j, i] = j_share
            end
        end

    end

    totals = []

    for i ∈ 1:l 
        append!(totals, sum(win_share[i,:]))
    end

    return win_share, totals

end

"""

winners = []

first_generation = q_vecgen(100);

@time begin

results₁ = running_qs(first_generation, 10);

end

r₁ = findmax(results₁[2])

first_gen_winner = first_generation[r₁[2]]

append!(winners, [first_gen_winner])



second_generation = q_vecgen(first_gen_winner, 100)

@time begin

results₂ = running_qs(second_generation,10)

end

r₂ = findmax(results₂)

second_gen_winner = second_generation[r₂[2]]

append!(winners, [second_gen_winner])


"""


function pokemon_generations(gens, num_vec, battles)

    winners = []

    scores = []

    first_gen = q_vecgen(num_vec)

    results = running_qs(first_gen, battles)

    r = findmax(results[2])

    first_winner = first_gen[r[2]]

    append!(winners, [first_winner])

    append!(scores, [results[2]])
    

    for i ∈ 1:(gens-1)

        gen = q_vecgen(last(winners), num_vec)

        g_results = running_qs(gen, battles)

        g_r = findmax(g_results[2])

        s_winner = gen[g_r[2]]

        append!(winners, [s_winner])

        append!(scores, [g_results[2]])

    end


    return winners, scores

    
end


@time begin

winners, scores = pokemon_generations(100, 10, 20)

end

# gens is multipicative, num_vec is squared, battles is multiplicative

# (4, 10, 20) should be around 2.5s ≈ 2.6s

# (100, 10, 20) should be around 2.5 * 25s ≈ 66s





FileIO.save(joinpath(@__DIR__,"tictacwinners.jld2"), "winners", winners)

dinners = FileIO.load(joinpath(@__DIR__,"tictacwinners.jld2"), "winners")


last_winner = last(dinners)

runrandtic(100, last_winner)


q_last = [last_winner[1] last_winner[2] last_winner[3];
    last_winner[4] last_winner[5] last_winner[6];
    last_winner[7] last_winner[8] last_winner[9]
]

q_r = [last_winner[10] last_winner[11] last_winner[12];
    last_winner[13] last_winner[14] last_winner[15];
    last_winner[16] last_winner[17] last_winner[18]
]

starting_q = [100 100 100;
100 100 100;
100 100 100
]

starting_r = [0.1 0.1 0.1;
0.1 0.1 0.1;
0.1 0.1 0.1
]




@time begin

    for i ∈ 1:10

        winners, scores = pokemon_generations(100, 10, 20)

        FileIO.save(joinpath(@__DIR__,"tictacwinners$i.jld2"), "winners$i", winners)

    end

end