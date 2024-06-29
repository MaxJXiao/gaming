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