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