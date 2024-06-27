using BenchmarkTools
using FileIO


eval₁ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test1.jld2"), "test1")
eval₂ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test2.jld2"), "test2")
eval₃ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test3.jld2"), "test3")
eval₄ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test4.jld2"), "test4")
eval₅ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test5.jld2"), "test5")
eval₆ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test6.jld2"), "test6")
eval₇ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test7.jld2"), "test7")
eval₈ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test8.jld2"), "test8")
eval₉ = FileIO.load(joinpath(@__DIR__, "ticcopy", "test9.jld2"), "test9")


board = [0 0 0 0 0 0 0 0 0]


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


function score(seq::Int)

    r_board()

    str = split(string(seq), "")
    l = length(str)

    for i ∈ 1:l

        if i % 2 == 1

            board[parse(Int, str[i])] = 1

        elseif i % 2 == 0

            board[parse(Int, str[i])] = -1

        end

        if i == l
            if board_state(board) == 1
                if i == 5
                    return 3
                elseif i == 6
                    return -2
                elseif i == 7
                    return 2
                elseif i == 8
                    return -1
                elseif i == 9
                    return 1
                end
            elseif board_state(board) == 0
                return 0
            elseif board_state(board) == -200
                return -200
            end
        end
    end


end



function seq_to_board(seq::Int)

    r_board()

    str = split(string(seq), "")
    l = length(str)

    for i ∈ 1:l

        if i % 2 == 1

            board[parse(Int, str[i])] = 1

        elseif i % 2 == 0

            board[parse(Int, str[i])] = -1

        end

    end


end


function seq_gen(board)
    mod = copy(board)
    parity = 1
    seq = []

    for j ∈ 1:9


        for i ∈ 1:9

            if mod[i] == 1 && parity == 1
                mod[i] = 0
                append!(seq, string(i))
                parity *= -1
                break

            elseif mod[i] == -1 && parity == -1
                mod[i] = 0
                append!(seq, string(i))
                parity *= -1
                break
            end



        end

    end

    if seq == []
        return 0
    else
        return parse(Int, join(seq))
    end

    
end


function current_eval(board)
    seq = seq_gen(board)
    l = length(split(string(seq), ""), )

    if seq == 0
        return 0
    elseif l == 1
        return 0
    elseif l == 2
        ind = findall(x -> (x == seq), eval₂[:, 1])
        return eval₂[ind, 2]
    elseif l == 3
        ind = findall(x -> (x == seq), eval₃[:, 1])
        return eval₃[ind, 2]
    elseif l == 4
        ind = findall(x -> (x == seq), eval₄[:, 1])
        return eval₄[ind, 2]
    elseif l == 5
        ind = findall(x -> (x == seq), eval₅[:, 1])
        return eval₅[ind, 2]
    elseif l == 6
        ind = findall(x -> (x == seq), eval₆[:, 1])
        return eval₆[ind, 2]
    elseif l == 7
        ind = findall(x -> (x == seq), eval₇[:, 1])
        return eval₇[ind, 2]
    elseif l == 8
        ind = findall(x -> (x == seq), eval₈[:, 1])
        return eval₈[ind, 2]
    elseif l == 9
        ind = findall(x -> (x == seq), eval₉[:, 1])
        return eval₉[ind, 2]
    end
    
end


function q_state(q_state, α)
    for i ∈ 1:9
        q_state[i] += α*randn()
    end
end

function q_vecgen(num, α)
    q_vecs = []
    for i ∈ 1:num
        q_vec = [10.0 10.0 10.0 10.0 10.0 10.0 10.0 10.0 10.0]

        q_state(q_vec, α)
        append!(q_vecs, [q_vec])
    end
    return q_vecs
end
function q_vecgen(arr, num, α)
    l = length(arr)
    q_vecs = []
    for i ∈ 1:l 
        append!(q_vecs, [arr[i]])
    end
    for i ∈ 1:(num-l)
        
        q_vec = random_effect(arr)

        q_state(q_vec, α)
        append!(q_vecs, [q_vec])

    end
    return q_vecs
end


function random_effect(arr)
    x = 10
    l = length(arr)
    result = [0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0]
    if x == 1
        for i ∈ 1:l 
            result .+= arr[i]./l
        end

    elseif x == 2
        y = rand(1:l)
        z = rand(1:l)
        ran = rand(1:9)
        san = rand(1:9)
        dan = rand(1:9)
        result .= (arr[y] .+ arr[z]) ./ 2
        result[ran] += randn()
        result[san] += randn()
        result[dan] += randn()

    elseif x == 3
        result .= (arr[1 % l + 1] .+ arr[3 % l + 1] .+ arr[5 % l + 1] + arr[7 % l + 1])./4

    elseif x == 4
        result .= (arr[2 % l + 1] .+ arr[4 % l + 1] .+ arr[6 % l + 1] + arr[8 % l + 1])./4

    elseif x == 5
        result .= (arr[1 % l + 1] .+ arr[l - 1] .+ arr[4 % l + 1] + arr[6 % l + 1])./4
    
    elseif x == 6
        result .= (arr[1] .+ arr[4 % l + 1]) ./ 2
        ran = rand(1:9)
        result[ran] += 2*randn()

    elseif x == 7
        result .= arr[1] .+ randn()

    elseif x == 8
        result .= (arr[2] .+ arr[3 % l + 1]) ./2
        result[5] += randn()

    elseif x == 9
        for i ∈ 1:9
            result[i] = arr[i % l + 1][i]
        end
    
    elseif x == 10
        result .= arr[1]

    end



    return result
end


function display_q(q_state)
    mat = [q_state[1] q_state[2] q_state[3];
    q_state[4] q_state[5] q_state[6];
    q_state[7] q_state[8] q_state[9]
    ]
    return mat
end

#test = q_vecgen(10,1)
#random_effect(test)
# combining

# [q_vecgen(10, 1) ; q_vecgen(test, 90, 1)] makes 100 vectors

function decider(board)

    seq = seq_gen(board)

    no_r = no_repeats(seq)
    new_seq = []
    choices = []

    if seq == 0
        for i ∈ no_r
            append!(new_seq, parse(Int, string(i) ) )
            append!(choices, i)
        end
    else
        for i ∈ no_r
            append!(new_seq, parse(Int, string(seq)*string(i) ) )
            append!(choices, i)

        end
    end

    l = length(split(string(new_seq[1]), ""), )
    r = length(no_r)



    eval = []



    for i ∈ 1:r 
        if l == 1
            append!(eval, 0)
        elseif l == 2
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₂[:, 1])
            append!(eval, eval₂[ind, 2])
        elseif l == 3
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₃[:, 1])
            append!(eval, eval₃[ind, 2])
        elseif l == 4
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₄[:, 1])
            append!(eval, eval₄[ind, 2])
        elseif l == 5
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₅[:, 1])
            append!(eval, eval₅[ind, 2])
        elseif l == 6
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₆[:, 1])
            append!(eval, eval₆[ind, 2])
        elseif l == 7
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₇[:, 1])
            append!(eval, eval₇[ind, 2])
        elseif l == 8
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₈[:, 1])
            append!(eval, eval₈[ind, 2])
        elseif l == 9
            ind = findall(x -> (x == transpose_order(new_seq[i])), eval₉[:, 1])
            append!(eval, eval₉[ind, 2])
        end
    end

    return new_seq, choices, eval

end







function prob_dist(vec)
    total = sum(vec)
    norm_vec = vec./total

    area = [0.0]

    l = length(vec)

    for i ∈ 1:l 
        append!(area, sum(norm_vec[1:i]))
    end

    return area
    
end

function prob_choice(vec)
    l = length(vec)
    x = rand()
    for i ∈ 1:(l-1)
        if x > vec[i] && x < vec[i + 1]
            return i
        end
    end
end



function transpose_order(seq)
    s = split(string(seq), "")
    l = length(s)
    odds = []
    evens = []

    for i ∈ 1:l 
        if i % 2 == 1
            append!(odds, parse(Int, s[i]))
        elseif i % 2 == 0
            append!(evens, parse(Int, s[i]))
        end
    end

    re_odd = sort(odds)
    re_even = sort(evens)

    empty = ""

    for i ∈ 1:l 
        if i % 2 == 1
            empty = empty*string(re_odd[Int((i + 1) / 2)])
        elseif i % 2 == 0
            empty = empty*string(re_even[Int(i / 2)])
        end
    end

    return parse(Int, empty)

    
end



function transpositions(evals::Matrix)

    set = Set([])

    lₑ = length(evals[:, 1])

    for i ∈ 1:lₑ

        r_board()

        seq = evals[i, 1]

        str = split(string(seq), "")

        l = length(str)

        for j ∈ 1:l

            if j % 2 == 1

                board[parse(Int, str[j])] = 1

            elseif j % 2 == 0

                board[parse(Int, str[j])] = -1

            end

        end

        new_seq = seq_gen(board)

        push!(set, [new_seq evals[i, 2]])

    end

    return set_to_matrix(set)

end

function set_to_matrix(set)
    seq, num = [], []
    for i ∈ set
        append!(seq, i[1])
        append!(num, i[2])
    end

    return [seq num]
    
end


function no_repeats()
    set = Set([1, 2, 3, 4, 5, 6, 7, 8, 9])
    return set
end
function no_repeats(seq)
    set = Set([1, 2, 3, 4, 5, 6, 7, 8, 9])


    str = string(seq, "")
    l = length(str)


    for i ∈ 1:l
        if parse(Int, str[i]) ∈ set
            pop!(set, parse(Int, str[i]))
        end
    end

    return set
    
end





function choosing(board, q_state)
    if sum(board) == 0
        _, choice, c_eval = decider(board)
        max = maximum(c_eval)
        q_s = []
        opt = []
        l = length(c_eval)
        for i ∈ 1:l
            if c_eval[i] == max
                append!(q_s, q_state[choice[i]])
                append!(opt, choice[i])
            end
        end

        
    elseif sum(board) == 1
        _, choice, c_eval = decider(board)
        min = minimum(c_eval)
        q_s = []
        opt = []
        l = length(c_eval)
        for i ∈ 1:l
            if c_eval[i] == min
                append!(q_s, q_state[choice[i]])
                append!(opt, choice[i])
            end
        end
    end

    return opt[prob_choice(prob_dist(q_s))]

end


"""
oness = 0
threes = 0
fives = 0
eights = 0


for i ∈ 1:1000
    k = choosing(board, q_vecgen(1,1))
    if k == 1
        oness += 1
    elseif k == 3
        threes += 1
    elseif k == 5
        fives += 1
    elseif k == 8
        eights += 1
    end

end

println([oness, threes, fives, eights])

"""



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

    points = [0.0 0.0]

    for j ∈ 1:runs

        r_board()


        if j % 2 == 1

            for i ∈ 1:9

                if i % 2 == 1
                    board[choosing(board, q)] = 1
                elseif i % 2 == 0
                    rand_xuan(board, i)
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        if i == 5
                            points[1] += 30 #3
                            break
                        elseif i == 7
                            points[1] += 2
                            break
                        elseif i == 9
                            points[1] += 1
                            break
                        end

                    elseif i % 2 == 0
                        points[1] -= 1000
                        break
                    end

                end

            end


        elseif j % 2 == 0

            for i ∈ 1:9

                if i % 2 == 1
                    rand_xuan(board, i)
                elseif i % 2 == 0
                    board[choosing(board, q)] = -1
                end

                if board_state(board) == 1
                    if i % 2 == 1
                        points[2] -= 1000
                        break
                    elseif i % 2 == 0
                        if i == 6
                            points[2] += 20 #2
                            break
                        elseif i == 8
                            points[2] += 1
                            break

                        end
                    end

                end

            end

        end


    end

    return points

end



function running_rands(block, battles)
    l = length(block)
    win_share = []

    for i ∈ 1:l 

        wins = runrandtic(battles, block[i])
        append!(win_share, sum(wins))


    end

    return win_share

end

# [q_vecgen(10, 1) ; q_vecgen(test, 90, 1)] makes 100 vectors

function pokemon_generations(gens, num_vec, α, best, battles)

    winners = []

    scores = []

    first_gen = q_vecgen(num_vec, α)

    results = running_rands(first_gen, battles)

    r = partialsortperm(results, 1:best, rev = true)

    first_winners = first_gen[r]

    append!(winners, [first_winners])

    append!(scores, [results])

    new = first_winners
    

    for i ∈ 1:(gens-1)

        gen = [q_vecgen(best, 1); q_vecgen(first_winners, num_vec - best, α)]

        g_results = running_rands(gen, battles)

        g_r = partialsortperm(g_results, 1:best, rev = true)

        s_winners = gen[g_r]

        append!(winners, [s_winners])

        append!(scores, [g_results])

        new = copy.(s_winners)

    end


    return winners, scores

    
end


α = [0, 0.1, 0.5, 1, 5]

@time begin

    for i ∈ 1:5
        β = α[i]

        winners, scores = pokemon_generations(10, 25, β, 5, 100)


        FileIO.save(joinpath(@__DIR__, "ticcopy", "opt_skew_wins$β.jld2"), "winners$β", winners)
        FileIO.save(joinpath(@__DIR__, "ticcopy", "opt_skew_scores$β.jld2"), "scores$β", scores)

        println(i)
    end

end

# pokemon_generations(N, N, _, _, N)
# pokemon_generations(gens, num_vec, α, best, battles)
# 2, 20, β, 10, 2 , 4x is 5.2s
# 10, 100, β, 10, 10, should be ≈ 5 × 125 = 625s
# 10, 25, β, 5, 100, should be ≈ 5 × 150 = 750s

## skew is when winning on turn 5 or 6 is boosted



# dinners_0 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_tics_wins0.0.jld2"), "winners0.0")
# dinners_0_1 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_tics_wins0.1.jld2"), "winners0.1")
# dinners_0_5 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_tics_wins0.5.jld2"), "winners0.5")
# dinners_1 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_tics_wins1.0.jld2"), "winners1.0")
# dinners_5 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_tics_wins5.0.jld2"), "winners5.0")



dinners_0 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_skew_wins0.0.jld2"), "winners0.0")
dinners_0_1 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_skew_wins0.1.jld2"), "winners0.1")
dinners_0_5 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_skew_wins0.5.jld2"), "winners0.5")
dinners_1 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_skew_wins1.0.jld2"), "winners1.0")
dinners_5 = FileIO.load(joinpath(@__DIR__, "ticcopy", "opt_skew_wins5.0.jld2"), "winners5.0")



win_0 = last(dinners_0)[1] # q_state

sco_0 = runrandtic(1000, win_0)

win_0_1 = last(dinners_0_1)[1]

sco_0_1 = runrandtic(1000, win_0_1)

win_0_5 = last(dinners_0_5)[1]

sco_0_5 = runrandtic(1000, win_0_5)

win_1 = last(dinners_1)[1]

sco_1 = runrandtic(1000, win_1)

win_5 = last(dinners_5)[1]

sco_5 = runrandtic(1000, win_5)

ran = q_vecgen(1,1)[1]

sco_rand = runrandtic(1000, ran)

sco = [sum(sco_rand), sum(sco_0), sum(sco_0_1), sum(sco_0_5), sum(sco_1), sum(sco_5)]

display_q(ran)

display_q(win_0)

display_q(win_0_1)

display_q(win_0_5)

display_q(win_1)

display_q(win_5)







function single_deep()

    output = []
    for i ∈ 1:9
        append!(output, [i])

    end

    return output
    
end
function single_deep(vec)

    set = Set([1, 2, 3, 4, 5, 6, 7, 8, 9])

    output = []

    l = length(vec)

    for i ∈ 1:l

        seq = vec[i]

        new_set = no_repeats(seq)

        for j ∈ new_set

            append!(output, [parse(Int, string(vec[i])*string(j))])

        end

    end

        return output
    
end

function completed_games(vec)
    l = length(vec)

    incomplete = []
    complete = []
    scores = []

    for i ∈ 1:l

        s = score(vec[i])

        if s == -200
            append!(incomplete, [vec[i]])
        else
            append!(complete, [vec[i]])
            append!(scores, [s])
        end
    end

    return complete, scores, incomplete

    
end



state₁ = single_deep()

state₂ = single_deep(state₁)

state₃ = single_deep(state₂)

state₄ = single_deep(state₃)

state₅ = single_deep(state₄)

complete₅, score₅, incomplete₅ = completed_games(state₅)

state₆ = single_deep(incomplete₅)

complete₆, score₆, incomplete₆ = completed_games(state₆)

state₇ = single_deep(incomplete₆)

complete₇, score₇, incomplete₇ = completed_games(state₇)

state₈ = single_deep(incomplete₇)

complete₈, score₈, incomplete₈ = completed_games(state₈)

state₉ = single_deep(incomplete₈)

_, score₉, _ = completed_games(state₉)

# 255168 complete sequences
complete_game_count = length(complete₅) + length(complete₆) + length(complete₇) + length(complete₈) + length(state₉)



eval₉ = [state₉ score₉]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval9.jld2"), "eval9", eval₉)


eval₈ = [incomplete₈ score₉;
    complete₈ score₈
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval8.jld2"), "eval8", eval₈)




iscores₇ = []
count = 0

@time begin

for i ∈ incomplete₇


    no_r = no_repeats(i)

    value = []

    for j ∈ no_r
        new = parse(Int, string(i)*string(j))
        append!(value, eval(new))
        #println(eval(new))
    end


    append!(iscores₇, minimum(value))

    count += 1

    if count % 1000 == 0

        println(count)

    end

end

end

eval₇ = [incomplete₇ iscores₇;
complete₇ score₇
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval7.jld2"), "eval7", eval₇)



iscores₆ = []
count = 0

@time begin

for i ∈ incomplete₆


    no_r = no_repeats(i)

    value = []

    for j ∈ no_r
        new = parse(Int, string(i)*string(j))
        append!(value, eval(new))
        #println(eval(new))
    end


    append!(iscores₆, maximum(value))

    count += 1

    if count % 1000 == 0

        println(count)

    end

end

end

eval₆ = [incomplete₆ iscores₆;
complete₆ score₆
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval6.jld2"), "eval6", eval₆)




iscores₅ = []
count = 0

@time begin

for i ∈ incomplete₅


    no_r = no_repeats(i)

    value = []

    for j ∈ no_r
        new = parse(Int, string(i)*string(j))
        append!(value, eval(new))
        #println(eval(new))
    end


    append!(iscores₅, minimum(value))

    count += 1

    if count % 1000 == 0

        println(count)

    end

end

end

eval₅ = [incomplete₅ iscores₅;
complete₅ score₅
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval5.jld2"), "eval5", eval₅)




iscores₄ = []
count = 0

@time begin

for i ∈ state₄


    no_r = no_repeats(i)

    value = []

    for j ∈ no_r
        new = parse(Int, string(i)*string(j))
        append!(value, eval(new))
        #println(eval(new))
    end


    append!(iscores₄, maximum(value))

    count += 1

    if count % 1000 == 0

        println(count)

    end

end

end

eval₄ = [state₄ iscores₄;
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval4.jld2"), "eval4", eval₄)



iscores₃ = []
count = 0

@time begin

for i ∈ state₃


    no_r = no_repeats(i)

    value = []

    for j ∈ no_r
        new = parse(Int, string(i)*string(j))
        append!(value, eval(new))
        #println(eval(new))
    end


    append!(iscores₃, minimum(value))

    count += 1

    if count % 1000 == 0

        println(count)

    end

end

end

eval₃ = [state₃ iscores₃
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval3.jld2"), "eval3", eval₃)




iscores₂ = []
count = 0

@time begin

for i ∈ state₂


    no_r = no_repeats(i)

    value = []

    for j ∈ no_r
        new = parse(Int, string(i)*string(j))
        append!(value, eval(new))
        #println(eval(new))
    end


    append!(iscores₂, maximum(value))

    count += 1

    if count % 1000 == 0

        println(count)

    end

end

end

eval₂ = [state₂ iscores₂;
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval2.jld2"), "eval2", eval₂)





iscores₁ = []
count = 0

@time begin

for i ∈ state₁


    no_r = no_repeats(i)

    value = []

    for j ∈ no_r
        new = parse(Int, string(i)*string(j))
        append!(value, eval(new))
        #println(eval(new))
    end


    append!(iscores₁, minimum(value))

    count += 1

    if count % 1000 == 0

        println(count)

    end

end

end

eval₁ = [state₁ iscores₁
]

FileIO.save(joinpath(@__DIR__, "ticcopy", "eval1.jld2"), "eval1", eval₁)



test₁ = transpositions(eval₁)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test1.jld2"), "test1", test₁)

test₂ = transpositions(eval₂)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test2.jld2"), "test2", test₂)

test₃ = transpositions(eval₃)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test3.jld2"), "test3", test₃)

test₄ = transpositions(eval₄)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test4.jld2"), "test4", test₄)

test₅ = transpositions(eval₅)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test5.jld2"), "test5", test₅)

test₆ = transpositions(eval₆)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test6.jld2"), "test6", test₆)

test₇ = transpositions(eval₇)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test7.jld2"), "test7", test₇)

test₈ = transpositions(eval₈)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test8.jld2"), "test8", test₈)

test₉ = transpositions(eval₉)

FileIO.save(joinpath(@__DIR__, "ticcopy", "test9.jld2"), "test9", test₉)


"""
function eval(seq)
    ind = findall(x -> (x == seq), eval₂[:, 1])
    return eval₂[ind, 2]
end

"""