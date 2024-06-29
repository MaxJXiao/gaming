using FileIO
using BenchmarkTools


board = zeros(6, 7)

function r_board()
    board .= 0
end


function screen(board)
    check = 0
    for i ∈ board
        if i == 0
            check += 1
        end
    end
    return check
end


function red_count(board)
    check = 0
    for i ∈ board
        if i == 1
            check += 1
        end
    end
    return check
end

function yellow_count(board)
    check = 0
    for i ∈ board
        if i == -1
            check += 1
        end
    end
    return check
end



function board_state(board)

    win = 0

    for i ∈ 6:-1:1
        if abs(board[i, 1] + board[i, 2] + board[i, 3] + board[i, 4]) == 4 ||
            abs(board[i, 2] + board[i, 3] + board[i, 4] + board[i, 5]) == 4 ||
            abs(board[i, 3] + board[i, 4] + board[i, 5] + board[i, 6]) == 4 ||
            abs(board[i, 4] + board[i, 5] + board[i, 6] + board[i, 7]) == 4
                win += 1
                break
        end

    end


    if win == 0
        for i ∈ 1:7
            if abs(board[3, i] + board[4, i] + board[5, i] + board[6, i]) == 4 ||
            abs(board[2, i] + board[3, i] + board[4, i] + board[5, i]) == 4 ||
            abs(board[1, i] + board[2, i] + board[3, i] + board[4, i]) == 4
                win += 1
                break
            end
        end
    end


    if win == 0
        for i ∈ 1:4
            if abs(board[3, i] + board[4, i + 1] + board[5, i + 2] + board[6, i + 3]) == 4 ||
                abs(board[6, i] + board[5, i + 1] + board[4, i + 2] + board[3, i + 3]) == 4 ||
                abs(board[2, i] + board[3, i + 1] + board[4, i + 2] + board[5, i + 3]) == 4 ||
                abs(board[5, i] + board[4, i + 1] + board[3, i + 2] + board[2, i + 3]) == 4 ||
                abs(board[1, i] + board[2, i + 1] + board[3, i + 2] + board[4, i + 3]) == 4 ||
                abs(board[4, i] + board[3, i + 1] + board[2, i + 2] + board[1, i + 3]) == 4
                    win += 1
                    break
            end

        end
    end

    if win == 1
        return 1
    elseif win == 0 && screen(board) == 0
        return 0
    else
        return -200
    end

end


function score(seq::Int)

    r_board()

    str = split(string(seq), "")
    l = length(str)

    pos = [6 6 6 6 6 6 6]

    for i ∈ 1:l

        if i % 2 == 1

            board[pos[parse(Int, str[i])], parse(Int, str[i])] = 1
            pos[parse(Int, str[i])] -= 1

        elseif i % 2 == 0

            board[pos[parse(Int, str[i])], parse(Int, str[i])] = -1
            pos[parse(Int, str[i])] -= 1

        end

        if i == l
            if board_state(board) == 1
                if i % 2 == 1
                    return 22 - red_count(board)
                elseif i % 2 == 0
                    return yellow_count(board) - 22
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

    pos = [6 6 6 6 6 6 6]

    for i ∈ 1:l


        if i % 2 == 1

            board[pos[parse(Int, str[i])], parse(Int, str[i])] = 1
            pos[parse(Int, str[i])] -= 1

        elseif i % 2 == 0

            board[pos[parse(Int, str[i])], parse(Int, str[i])] = -1
            pos[parse(Int, str[i])] -= 1

        end

    end


end



function seq_gen(board)
    mod = copy(board)

    red = []
    yellow = []



    for n ∈ 42:-1:1

        i = (n - 1) % 7 + 1
        j = floor(Int, (n - 1) / 7 + 1)


        if mod[j, i] == 1

            append!(red, string(i))

        elseif mod[j, i] == -1

            append!(yellow, string(i))

        end

    end

    seq = ""

    l = length(red) + length(yellow)

    for i ∈ 1:l 
        if i % 2 == 1
            seq = seq*red[Int((i + 1) / 2)]
        elseif i % 2 == 0
            seq = seq*yellow[Int(i / 2)]
        end
    end


    if seq == ""
        return 0
    else
        return parse(Int, seq)
    end

    
end


function no_stacks()
    set = Set([1, 2, 3, 4, 5, 6, 7])
    return set
end
function no_stacks(seq)
    set = Set([1, 2, 3, 4, 5, 6, 7])


    str = string(seq, "")
    l = length(str)

    for i ∈ 1:7
        count = 0
        for j ∈ 1:l
            if i == parse(Int, str[j])
                count += 1
            end
        end
        if count == 6
            pop!(set, i)
        end
    end

    return set
    
end


function transpose_order(seq::Int)
    
    seq_to_board(seq)
    return seq_gen(board)

    
end

function transpose_order(vec::Vector)
    raw = []
    for i ∈ vec
        append!(raw, transpose_order(i))
    end

    return unique(raw)

    
end



function single_deep()

    output = []
    for i ∈ 1:7
        append!(output, [i])

    end

    return output
    
end
function single_deep(seq)

    new_set = no_stacks(seq)

    raw = []
    for j ∈ new_set
        append!(raw, [parse(Int, string(seq)*string(j))])

    end

    return transpose_order(raw)
    
end
function single_deep(vec)

    raw = []

    l = length(vec)

    for i ∈ 1:l

        seq = vec[i]

        new_set = no_stacks(seq)

        for j ∈ new_set

            append!(raw, [parse(Int, string(vec[i])*string(j))])

        end

    end

        return transpose_order(raw)
    
end




"""


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


state_1 = single_deep()

FileIO.save(joinpath(@__DIR__, "c4state", "state1.jld2"), "state1", state_1)

state_2 = single_deep(state_1)

FileIO.save(joinpath(@__DIR__, "c4state", "state2.jld2"), "state2", state_2)

state_3 = single_deep(state_2)

FileIO.save(joinpath(@__DIR__, "c4state", "state3.jld2"), "state3", state_3)

state_4 = single_deep(state_3)

FileIO.save(joinpath(@__DIR__, "c4state", "state4.jld2"), "state4", state_4)

state_5 = single_deep(state_4)

FileIO.save(joinpath(@__DIR__, "c4state", "state5.jld2"), "state5", state_5)

state_6 = single_deep(state_5)

FileIO.save(joinpath(@__DIR__, "c4state", "state6.jld2"), "state6", state_6)





s_7 = single_deep(state_6)

state_7 = completed_games(state_7)

FileIO.save(joinpath(@__DIR__, "c4state", "state7.jld2"), "state7", state_7)



s_8 = single_deep(state_7[3])

state_8 = completed_games(s_8)

FileIO.save(joinpath(@__DIR__, "c4state", "state8.jld2"), "state8", state_8)



s_9 = single_deep(state_8[3])

state_9 = completed_games(s_9)

FileIO.save(joinpath(@__DIR__, "c4state", "state9.jld2"), "state9", state_9)



s_10 = single_deep(state_9[3])

state_10 = completed_games(s_10)

FileIO.save(joinpath(@__DIR__, "c4state", "state10.jld2"), "state10", state_10)


@time begin

s_11 = single_deep(state_10[3])

end

# 41 seconds


"""