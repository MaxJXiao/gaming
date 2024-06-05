files = ["a" "b" "c" "d" "e" "f" "g" "h"]
numbers = ["1" "2" "3" "4" "5" "6" "7" "8"]


r_white = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "p" "p" "p" "p" "p" "p" "p" "p";
    "R" "N" "B" "Q" "K" "B" "N" "R"
]
w_castle = [0]
w_lrook = [0]
w_rrook = [0]
w_king = [8,5]


r_black = ["R" "N" "B" "Q" "K" "B" "N" "R";
    "p" "p" "p" "p" "p" "p" "p" "p";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" ""
]
b_castle = [0]
b_lrook = [0]
b_rrook = [0]
b_king = [1,5]


r_b = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" ""
]

b = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" ""
]


white = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "p" "p" "p" "p" "p" "p" "p" "p";
    "R" "N" "B" "Q" "K" "B" "N" "R"
]


black = ["R" "N" "B" "Q" "K" "B" "N" "R";
"p" "p" "p" "p" "p" "p" "p" "p";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" ""
]


"""
reset()

Reset pieces
"""
function reset()
    white .= r_white
    black .= r_black
    b .= r_b

    w_king .= [8, 5]
    b_king .= [1, 5]
    
    w_castle[1] *= 0
    b_castle[1] *= 0
    w_lrook[1] *= 0
    b_lrook[1] *= 0
    w_rrook[1] *= 0
    b_rrook[1] *= 0
end


"""
w_reset()

Reset pieces for white
"""
function w_reset()
    white .= r_white

    w_castle[1] *= 0
    w_lrook[1] *= 0
    w_rrook[1] *= 0
end

"""
b_reset()

Reset pieces for black
"""
function b_reset()
    black .= r_black
    
    b_castle[1] *= 0
    b_lrook[1] *= 0
    b_rrook[1] *= 0
end


"""
board()

Show board with all pieces on
"""
function board()
    b .= r_b
    for i ∈ eachindex(white)
        if white[i] != ""
            b[i] = white[i]
        end
        if black[i] != ""
            b[i] = black[i]
        end

    end
    return b
    
end



# need to define all legal moves

# while gaming != true
# turn

# switch *= -1

# check legality after

"""
convert_file()

check which file we are talking about
"""
function convert_file(letter::SubString{String})
    for i ∈ 1:8
        if letter == files[i]
            return i
        end
    end
end


"""
piece_interception()

Figure out the squares that can intercept the movement
"""
function piece_interception(rank,col,og_rank,og_col)
    if rank != og_rank && col != og_col
        s_rank = []

        if rank > og_rank
            append!(s_rank, rank:-1:og_rank)
        elseif og_rank > rank
            append!(s_rank, rank:og_rank)
        end

        s_col = []

        if col > og_col
            append!(s_col, col:-1:og_col)
        elseif og_col > col
            append!(s_col, col:og_col)
        end


        indices = []

        l = length(s_rank)
        if l > 2
            for i ∈ 2:l-1 
                append!(indices, [[s_rank[i], s_col[i]]])
            end
        end

    elseif rank != og_rank && col == og_col
        s_rank = []
        if abs(rank - og_rank) > 1
            if rank > og_rank
                i_rank = rank:-1:og_rank
                append!(s_rank, i_rank[2:end-1])
            else
                i_rank = rank:og_rank
                append!(s_rank, i_rank[2:end-1])
            end
        end
        
        indices = []

        l = length(s_rank)
        if l != 0
            for i ∈ 1:l 
                append!(indices, [[s_rank[i], col]])
            end
        end

    elseif col != og_col && rank == og_rank
        s_col = []
        if abs(col - og_col) > 1
            if col > og_col
                i_col = col:-1:og_col
                append!(s_col, i_col[2:end-1])
            else
                i_col = col:og_col
                append!(s_col, i_col[2:end-1])
            end
        end
        
        indices = []

        l = length(s_col)
        if l != 0
            for i ∈ 1:l 
                append!(indices, [[rank, s_col[i]]])
            end
        end

    end

    return indices
end


"""
line_of_sight()

See if black or white can block the movement
"""
function line_of_sight(cept::Vector{Any})
    l = length(cept)
    count = 0
    if l != 0

        for i ∈ 1:l 
            if white[cept[i][1],cept[i][2]] != "" || black[cept[i][1],cept[i][2]] != ""
                count += 1
                break
            end

        end
    end

    return count
    
end


"""
remove_white_enpassant()

Remove the identifier that last turn was an en passant for white
"""
function remove_white_enpassant()
    for i ∈ 1:8
        if white[5,i] == "pe"
            white[5,i] = "p"
        end
    end
end


"""
remove_black_enpassant()

Remove the identifier that last turn was an en passant for black
"""
function remove_black_enpassant()
    for i ∈ 1:8
        if black[4,i] == "pe"
            black[4,i] = "p"
        end
    end
end


#################### MOVES ##########################


"""
white_move()

Figure out which piece white wants to move.

"""
function white_move(move::String)
    splitter = split(move, "")
    if splitter[1] ∈ files
        white_pawn(move)
    elseif splitter[1] == "N"
        white_knight(move)
    elseif splitter[1] == "B"
        white_bisharp(move)
    elseif splitter[1] == "R"
        white_rook(move)
        if w_castle == 0
            if white[8,1] != "R"
                w_lrook += 1
            elseif white[8,8] != "R"
                w_rrook += 1
            end
        end
    elseif splitter[1] == "Q"
        white_queen(move)
    elseif splitter[1] == "K"
        white_king(move)
        w_castle[1] += 1
    elseif splitter[1] == "O"
        white_castle(move)
    end
    remove_black_enpassant()
end


"""
black_move()

Figure out which piece black wants to move.

"""
function black_move(move::String)
    splitter = split(move, "")
    if splitter[1] ∈ files
        black_pawn(move)
    elseif splitter[1] == "N"
        black_knight(move)
    elseif splitter[1] == "B"
        black_bisharp(move)
    elseif splitter[1] == "R"
        black_rook(move)
        if b_castle == 0
            if black[1,1] != "R"
                b_lrook += 1
            elseif black[1,8] != "R"
                b_rrook += 1
            end
        end
    elseif splitter[1] == "Q"
        black_queen(move)
    elseif splitter[1] == "K"
        black_king(move)
        b_castle[1] += 1
    elseif splitter[1] == "O"
        black_castle(move)
    end
    remove_white_enpassant()
end


"""
white_pawn()

Move white pawn, simplified method probably
"""
function white_pawn(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 2
        col = convert_file(splitter[1])
        rank = 9 - parse(Int, splitter[2])

        if white[rank + 1, col] == "p" && black[rank,col] == "" && white[rank,col] == ""
            white[rank + 1, col] = ""
            white[rank, col] = "p"
        elseif white[rank + 1, col] == "pe" && black[rank,col] == "" && white[rank,col] == ""
            white[rank + 1, col] = ""
            white[rank, col] = "p"
        end

        if rank == 5 # change to 4 for black and + +> -
            if white[rank + 2, col] == "p" &&
                white[rank + 1, col] == "" && black[rank + 1, col] == "" &&
                white[rank,col] == "" && black[rank,col] == ""
                    white[rank + 2, col] = ""
                    white[rank,col] = "pe"
            end
        end

    elseif l == 4
        if splitter[2] == "8"
            col = convert_file(splitter[1])
            rank = 9 - parse(Int, splitter[2]) # for consistency for black
            if white[rank + 1, col] == "p" && black[rank, col] == "" && white[rank,col] == ""
                white[rank + 1, col] = ""
                white[rank, col] = string(splitter[4])
            end
        
        elseif splitter[2] == "x"
            og_col = convert_file(splitter[1])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4]) 

            if white[rank + 1, og_col] == "p" && black[rank, col] != "" &&
                white[rank, col] == ""
                    white[rank + 1, og_col] = ""
                    white[rank, col] = "p"
                    black[rank, col] = ""
            elseif white[rank + 1, og_col] == "pe" && black[rank, col] != "" &&
                white[rank,col] == ""
                    white[rank + 1, og_col] = ""
                    white[rank, col] = "p"
                    black[rank, col] = ""

            # en_passant
            elseif rank == 3 && white[rank + 1, og_col] == "p" &&
                white[rank, col] == "" && black[rank, col] == "" &&
                black[rank + 1, col] == "pe"
                    white[rank + 1, og_col] = ""
                    white[rank, col] = "p"
                    black[rank + 1, col] = ""
            end

        end
    
    elseif l == 6
        og_col = convert_file(splitter[1])

        col = convert_file(splitter[3])
        rank = 9 - parse(Int, splitter[4])

        if white[rank + 1, og_col] == "p" && black[rank, col] != "" &&
            white[rank, col] == ""
                white[rank + 1, og_col] = ""
                white[rank, col] = string(splitter[6])
                black[rank, col] = ""
        end

    end


end


"""
black_pawn()

Move black pawn, simplified method probably
"""
function black_pawn(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 2
        col = convert_file(splitter[1])
        rank = 9 - parse(Int, splitter[2])

        if black[rank - 1, col] == "p" && white[rank,col] == "" && black[rank,col] == ""
            black[rank - 1, col] = ""
            black[rank, col] = "p"
        elseif black[rank - 1, col] == "pe" && white[rank,col] == "" && black[rank,col] == ""
            black[rank - 1, col] = ""
            black[rank, col] = "p"
        end

        if rank == 4 # change to 4 for black and + +> -
            if black[rank - 2, col] == "p" &&
                black[rank - 1, col] == "" && white[rank - 1, col] == "" &&
                black[rank,col] == "" && white[rank,col] == ""
                    black[rank - 2, col] = ""
                    black[rank, col] = "pe"
            end
        end

    elseif l == 4
        if splitter[2] == "1"
            col = convert_file(splitter[1])
            rank = 9 - parse(Int, splitter[2]) # for consistency for black
            if black[rank - 1, col] == "p" && white[rank, col] == "" && black[rank,col] == ""
                black[rank - 1, col] = ""
                black[rank, col] = string(splitter[4])
            end
        
        elseif splitter[2] == "x"
            og_col = convert_file(splitter[1])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4]) 

            if black[rank - 1, og_col] == "p" && white[rank, col] != "" &&
                black[rank, col] == ""
                    black[rank - 1, og_col] = ""
                    black[rank, col] = "p"
                    white[rank, col] = ""
            elseif black[rank - 1, og_col] == "pe" && white[rank, col] != "" &&
                black[rank,col] == ""
                    black[rank - 1, og_col] = ""
                    black[rank, col] = "p"
                    white[rank, col] = ""

            # en_passant
            elseif rank == 6 && black[rank - 1, og_col] == "p" &&
                black[rank, col] == "" && white[rank, col] == "" &&
                white[rank - 1, col] == "pe"
                    black[rank - 1, og_col] = ""
                    black[rank, col] = "p"
                    white[rank - 1, col] = ""
            end

        end
    
    elseif l == 6
        og_col = convert_file(splitter[1])

        col = convert_file(splitter[3])
        rank = 9 - parse(Int, splitter[4])

        if black[rank - 1, og_col] == "p" && white[rank, col] != "" &&
            black[rank, col] == ""
                black[rank - 1, og_col] = ""
                black[rank, col] = string(splitter[6])
                white[rank, col] = ""
        end

    end


end


"""
white_knight()

Move the white knight.
"""
function white_knight(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ knight_surround(rank, col)
            if white[i[1], i[2]] == "N" && black[rank, col] == "" && white[rank, col] == ""
                white[i[1], i[2]] = ""
                white[rank, col] = "N"
                break
            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ knight_surround(rank,col)
                if white[i[1], i[2]] == "N" && black[rank, col] != "" && white[rank, col] == ""
                    white[i[1], i[2]] = ""
                    white[rank, col] = "N"
                    black[rank, col] = ""
                    break
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ knight_surround(rank, col)
                if white[i[1], i[2]] == "N" && i[2] == og_col &&
                    white[rank, col] == "" && black[rank, col] == ""
                        white[i[1], i[2]] = ""
                        white[rank, col] = "N"
                        break
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ knight_surround(rank, col)
                if white[i[1], i[2]] == "N" && i[1] == og_rank &&
                    white[rank, col] == "" && black[rank, col] == ""
                        white[i[1], i[2]] = ""
                        white[rank, col] = "N"
                        break
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ knight_surround(rank, col)
                    if white[i[1], i[2]] == "N" && i[2] == og_col &&
                        white[rank, col] == "" && black[rank, col] != ""
                            white[i[1], i[2]] = ""
                            white[rank, col] = "N"
                            black[rank, col] = ""
                            break
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ knight_surround(rank, col)
                    if white[i[1], i[2]] == "N" && i[1] == og_rank &&
                        white[rank, col] == "" && black[rank, col] != ""
                            white[i[1], i[2]] = ""
                            white[rank, col] = "N"
                            black[rank, col] = ""
                            break
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if white[og_rank, og_col] == "N" && white[rank, col] == "" &&
                black[rank, col] == ""
                    white[og_rank, og_col] = ""
                    white[rank, col] = "N"
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if white[og_rank, og_col] == "N" && black[rank, col] != "" &&
                white[rank, col] == ""
                    white[og_rank, og_col] = ""
                    white[rank, col] = "N"
                    black[rank, col] = ""
            end

        end
    end

end


"""
black_knight()

Move the black knight.
"""
function black_knight(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ knight_surround(rank, col)
            if black[i[1], i[2]] == "N" && white[rank, col] == "" && black[rank, col] == ""
                black[i[1], i[2]] = ""
                black[rank, col] = "N"
                break
            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ knight_surround(rank,col)
                if black[i[1], i[2]] == "N" && white[rank, col] != "" && black[rank, col] == ""
                    black[i[1], i[2]] = ""
                    black[rank, col] = "N"
                    white[rank, col] = ""
                    break
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ knight_surround(rank, col)
                if black[i[1], i[2]] == "N" && i[2] == og_col &&
                    black[rank, col] == "" && white[rank, col] == ""
                        black[i[1], i[2]] = ""
                        black[rank, col] = "N"
                        break
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ knight_surround(rank, col)
                if black[i[1], i[2]] == "N" && i[1] == og_rank &&
                    black[rank, col] == "" && white[rank, col] == ""
                        black[i[1], i[2]] = ""
                        black[rank, col] = "N"
                        break
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ knight_surround(rank, col)
                    if black[i[1], i[2]] == "N" && i[2] == og_col &&
                        black[rank, col] == "" && white[rank, col] != ""
                            black[i[1], i[2]] = ""
                            black[rank, col] = "N"
                            white[rank, col] = ""
                            break
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ knight_surround(rank, col)
                    if black[i[1], i[2]] == "N" && i[1] == og_rank &&
                        black[rank, col] == "" && white[rank, col] != ""
                            black[i[1], i[2]] = ""
                            black[rank, col] = "N"
                            white[rank, col] = ""
                            break
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if black[og_rank, og_col] == "N" && black[rank, col] == "" &&
                white[rank, col] == ""
                    black[og_rank, og_col] = ""
                    black[rank, col] = "N"
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if black[og_rank, og_col] == "N" && white[rank, col] != "" &&
                black[rank, col] == ""
                    black[og_rank, og_col] = ""
                    black[rank, col] = "N"
                    white[rank, col] = ""
            end

        end
    end

end


"""
knight_surround()

find all the spots the knight could jump into the square from
"""
function knight_surround(rank, col)
    s_rank = []
    c_rank = []
    s_col = []
    c_col = []

    indices = []


    if rank - 2 > 0.5
        append!(s_rank, rank - 2)
        append!(c_rank, 2)
    end
    if rank - 1 > 0.5
        append!(s_rank, rank - 1)
        append!(c_rank, 1)
    end
    if rank + 2 < 8.5
        append!(s_rank, rank + 2)
        append!(c_rank, 2)
    end
    if rank + 1 < 8.5
        append!(s_rank, rank + 1)
        append!(c_rank, 1)
    end

    if col - 2 > 0.5
        append!(s_col, col - 2)
        append!(c_col, 2)
    end
    if col - 1 > 0.5
        append!(s_col, col - 1)
        append!(c_col, 1)
    end
    if col + 2 < 8.5
        append!(s_col, col + 2)
        append!(c_col, 2)
    end
    if col + 1 < 8.5
        append!(s_col, col + 1)
        append!(c_col, 1)
    end

    m = length(s_rank)
    n = length(s_col)

    for i ∈ 1:m 
        for j ∈ 1:n 
            if c_rank[i]^2 + c_col[j]^2 == 5
                append!(indices, [[s_rank[i],s_col[j]]])
            end
        end
    end

    return indices

end


"""
white_bisharp()

Move the white bisharp.
"""
function white_bisharp(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ bisharp_surround(rank, col)
            if white[i[1], i[2]] == "B" && black[rank, col] == "" && white[rank, col] == ""

                if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                    white[i[1], i[2]] = ""
                    white[rank, col] = "B"
                    break
                end

            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ bisharp_surround(rank,col)
                if white[i[1], i[2]] == "B" && black[rank, col] != "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                        white[i[1], i[2]] = ""
                        white[rank, col] = "B"
                        black[rank, col] = ""
                        break
                    end
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ bisharp_surround(rank, col)
                if white[i[1], i[2]] == "B" && i[2] == og_col &&
                    white[rank, col] == "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        white[i[1], i[2]] = ""
                        white[rank, col] = "B"
                        break
                    end
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ bisharp_surround(rank, col)
                if white[i[1], i[2]] == "B" && i[1] == og_rank &&
                    white[rank, col] == "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        white[i[1], i[2]] = ""
                        white[rank, col] = "B"
                        break
                    end
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ bisharp_surround(rank, col)
                    if white[i[1], i[2]] == "B" && i[2] == og_col &&
                        white[rank, col] == "" && black[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            white[i[1], i[2]] = ""
                            white[rank, col] = "B"
                            black[rank, col] = ""
                            break
                        end
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ bisharp_surround(rank, col)
                    if white[i[1], i[2]] == "B" && i[1] == og_rank &&
                        white[rank, col] == "" && black[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            white[i[1], i[2]] = ""
                            white[rank, col] = "B"
                            black[rank, col] = ""
                            break
                        end
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if white[og_rank, og_col] == "B" && white[rank, col] == "" &&
                black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    white[og_rank, og_col] = ""
                    white[rank, col] = "B"
                    
                end
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if white[og_rank, og_col] == "B" && black[rank, col] != "" &&
                white[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    white[og_rank, og_col] = ""
                    white[rank, col] = "B"
                    black[rank, col] = ""
                end
            end

        end
    end

end


"""
black_bisharp()

Move the black bisharp.
"""
function black_bisharp(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ bisharp_surround(rank, col)
            if black[i[1], i[2]] == "B" && white[rank, col] == "" && black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                    black[i[1], i[2]] = ""
                    black[rank, col] = "B"
                    break
                end
            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ bisharp_surround(rank,col)
                if black[i[1], i[2]] == "B" && white[rank, col] != "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "B"
                        white[rank, col] = ""
                        break
                    end
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ bisharp_surround(rank, col)
                if black[i[1], i[2]] == "B" && i[2] == og_col &&
                    black[rank, col] == "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "B"
                        break
                    end
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ bisharp_surround(rank, col)
                if black[i[1], i[2]] == "B" && i[1] == og_rank &&
                    black[rank, col] == "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "B"
                        break
                    end
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ bisharp_surround(rank, col)
                    if black[i[1], i[2]] == "B" && i[2] == og_col &&
                        black[rank, col] == "" && white[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            black[i[1], i[2]] = ""
                            black[rank, col] = "B"
                            white[rank, col] = ""
                            break
                        end
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ bisharp_surround(rank, col)
                    if black[i[1], i[2]] == "B" && i[1] == og_rank &&
                        black[rank, col] == "" && white[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            black[i[1], i[2]] = ""
                            black[rank, col] = "B"
                            white[rank, col] = ""
                            break
                        end
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if black[og_rank, og_col] == "B" && black[rank, col] == "" &&
                white[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    black[og_rank, og_col] = ""
                    black[rank, col] = "B"
                end
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if black[og_rank, og_col] == "B" && white[rank, col] != "" &&
                black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    black[og_rank, og_col] = ""
                    black[rank, col] = "B"
                    white[rank, col] = ""
                end
            end

        end
    end

end


"""
bisharp_surround()

find all spots the bisharp could jump into the square from
"""
function bisharp_surround(rank, col)
    indices = []

    for i ∈ 1:7
        if rank - i > 0.5 && col - i > 0.5
            append!(indices, [[rank - i, col - i]])
        end
        if rank - i > 0.5 && col + i < 8.5
            append!(indices, [[rank - i, col + i]])
        end
        if rank + i < 8.5 && col - i > 0.5
            append!(indices, [[rank + i, col - i]])
        end
        if rank + i < 8.5 && col + i < 8.5
            append!(indices, [[rank + i, col + i]])
        end
    end

    return indices
    
end


"""
white_rook()

Move the white rook.
"""
function white_rook(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ rook_surround(rank, col)
            if white[i[1], i[2]] == "R" && black[rank, col] == "" && white[rank, col] == ""

                if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                    white[i[1], i[2]] = ""
                    white[rank, col] = "R"
                    break
                end

            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ rook_surround(rank,col)
                if white[i[1], i[2]] == "R" && black[rank, col] != "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                        white[i[1], i[2]] = ""
                        white[rank, col] = "R"
                        black[rank, col] = ""
                        break
                    end
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ rook_surround(rank, col)
                if white[i[1], i[2]] == "R" && i[2] == og_col &&
                    white[rank, col] == "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        white[i[1], i[2]] = ""
                        white[rank, col] = "R"
                        break
                    end
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ rook_surround(rank, col)
                if white[i[1], i[2]] == "R" && i[1] == og_rank &&
                    white[rank, col] == "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        white[i[1], i[2]] = ""
                        white[rank, col] = "R"
                        break
                    end
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ rook_surround(rank, col)
                    if white[i[1], i[2]] == "R" && i[2] == og_col &&
                        white[rank, col] == "" && black[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            white[i[1], i[2]] = ""
                            white[rank, col] = "R"
                            black[rank, col] = ""
                            break
                        end
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ rook_surround(rank, col)
                    if white[i[1], i[2]] == "R" && i[1] == og_rank &&
                        white[rank, col] == "" && black[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            white[i[1], i[2]] = ""
                            white[rank, col] = "R"
                            black[rank, col] = ""
                            break
                        end
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if white[og_rank, og_col] == "R" && white[rank, col] == "" &&
                black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    white[og_rank, og_col] = ""
                    white[rank, col] = "R"
                    
                end
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if white[og_rank, og_col] == "R" && black[rank, col] != "" &&
                white[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    white[og_rank, og_col] = ""
                    white[rank, col] = "R"
                    black[rank, col] = ""
                end
            end

        end
    end

end


"""
black_rook()

Move the black rook.
"""
function black_rook(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ rook_surround(rank, col)
            if black[i[1], i[2]] == "R" && white[rank, col] == "" && black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                    black[i[1], i[2]] = ""
                    black[rank, col] = "R"
                    break
                end
            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ rook_surround(rank,col)
                if black[i[1], i[2]] == "R" && white[rank, col] != "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "R"
                        white[rank, col] = ""
                        break
                    end
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ rook_surround(rank, col)
                if black[i[1], i[2]] == "R" && i[2] == og_col &&
                    black[rank, col] == "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "R"
                        break
                    end
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ rook_surround(rank, col)
                if black[i[1], i[2]] == "R" && i[1] == og_rank &&
                    black[rank, col] == "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "R"
                        break
                    end
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ rook_surround(rank, col)
                    if black[i[1], i[2]] == "R" && i[2] == og_col &&
                        black[rank, col] == "" && white[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            black[i[1], i[2]] = ""
                            black[rank, col] = "R"
                            white[rank, col] = ""
                            break
                        end
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ rook_surround(rank, col)
                    if black[i[1], i[2]] == "R" && i[1] == og_rank &&
                        black[rank, col] == "" && white[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            black[i[1], i[2]] = ""
                            black[rank, col] = "R"
                            white[rank, col] = ""
                            break
                        end
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if black[og_rank, og_col] == "R" && black[rank, col] == "" &&
                white[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    black[og_rank, og_col] = ""
                    black[rank, col] = "R"
                end
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if black[og_rank, og_col] == "R" && white[rank, col] != "" &&
                black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    black[og_rank, og_col] = ""
                    black[rank, col] = "R"
                    white[rank, col] = ""
                end
            end

        end
    end

end


"""
rook_surround()

find all spots the rook could jump into the square from
"""
function rook_surround(rank, col)
    indices = []
    for i ∈ 1:7
        if rank - i > 0.5
            append!(indices, [[rank - i, col]])
        end
        if rank + i < 8.5
            append!(indices, [[rank + i, col]])
        end
        if col - i > 0.5
            append!(indices,[[rank, col - i]])
        end
        if col + i < 8.5
            append!(indices,[[rank, col + i]])
        end

    end

    return indices
    
end


"""
white_queen()

Move the white queen.
"""
function white_queen(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ queen_surround(rank, col)
            if white[i[1], i[2]] == "Q" && black[rank, col] == "" && white[rank, col] == ""

                if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                    white[i[1], i[2]] = ""
                    white[rank, col] = "Q"
                    break
                end

            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ queen_surround(rank,col)
                if white[i[1], i[2]] == "Q" && black[rank, col] != "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                        white[i[1], i[2]] = ""
                        white[rank, col] = "Q"
                        black[rank, col] = ""
                        break
                    end
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ queen_surround(rank, col)
                if white[i[1], i[2]] == "Q" && i[2] == og_col &&
                    white[rank, col] == "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        white[i[1], i[2]] = ""
                        white[rank, col] = "Q"
                        break
                    end
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ queen_surround(rank, col)
                if white[i[1], i[2]] == "Q" && i[1] == og_rank &&
                    white[rank, col] == "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        white[i[1], i[2]] = ""
                        white[rank, col] = "Q"
                        break
                    end
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ queen_surround(rank, col)
                    if white[i[1], i[2]] == "Q" && i[2] == og_col &&
                        white[rank, col] == "" && black[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            white[i[1], i[2]] = ""
                            white[rank, col] = "Q"
                            black[rank, col] = ""
                            break
                        end
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ queen_surround(rank, col)
                    if white[i[1], i[2]] == "Q" && i[1] == og_rank &&
                        white[rank, col] == "" && black[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            white[i[1], i[2]] = ""
                            white[rank, col] = "Q"
                            black[rank, col] = ""
                            break
                        end
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if white[og_rank, og_col] == "Q" && white[rank, col] == "" &&
                black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    white[og_rank, og_col] = ""
                    white[rank, col] = "Q"
                    
                end
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if white[og_rank, og_col] == "Q" && black[rank, col] != "" &&
                white[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    white[og_rank, og_col] = ""
                    white[rank, col] = "Q"
                    black[rank, col] = ""
                end
            end

        end
    end

end


"""
black_queen()

Move the black queen.
"""
function black_queen(move::String)
    splitter = split(move, "")

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        for i ∈ queen_surround(rank, col)
            if black[i[1], i[2]] == "Q" && white[rank, col] == "" && black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                    black[i[1], i[2]] = ""
                    black[rank, col] = "Q"
                    break
                end
            end
        end

    elseif l == 4

        if splitter[2] == "x"
            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ queen_surround(rank,col)
                if black[i[1], i[2]] == "Q" && white[rank, col] != "" && black[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "Q"
                        white[rank, col] = ""
                        break
                    end
                end

            end
        
        elseif splitter[2] ∈ files # Nbd2
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int,splitter[4])

            for i ∈ queen_surround(rank, col)
                if black[i[1], i[2]] == "Q" && i[2] == og_col &&
                    black[rank, col] == "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "Q"
                        break
                    end
                end
            end

        elseif splitter[2] ∈ numbers # N3d4
            og_rank = 9 - parse(Int, splitter[2])

            col = convert_file(splitter[3])
            rank = 9 - parse(Int, splitter[4])

            for i ∈ queen_surround(rank, col)
                if black[i[1], i[2]] == "Q" && i[1] == og_rank &&
                    black[rank, col] == "" && white[rank, col] == ""
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                        black[i[1], i[2]] = ""
                        black[rank, col] = "Q"
                        break
                    end
                end
            end

        end

    elseif l == 5
        if splitter[3] == "x"
            if splitter[2] ∈ files # Ncxe5
                og_col = convert_file(splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ queen_surround(rank, col)
                    if black[i[1], i[2]] == "Q" && i[2] == og_col &&
                        black[rank, col] == "" && white[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            black[i[1], i[2]] = ""
                            black[rank, col] = "Q"
                            white[rank, col] = ""
                            break
                        end
                    end
                end

            elseif splitter[2] ∈ numbers # N3xd4
                og_rank = 9 - parse(Int, splitter[2])

                col = convert_file(splitter[4])
                rank = 9 - parse(Int, splitter[5])

                for i ∈ queen_surround(rank, col)
                    if black[i[1], i[2]] == "Q" && i[1] == og_rank &&
                        black[rank, col] == "" && white[rank, col] != ""
                        if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0

                            black[i[1], i[2]] = ""
                            black[rank, col] = "Q"
                            white[rank, col] = ""
                            break
                        end
                    end
                end
                    

            end

        elseif splitter[3] ∈ numbers # Nf2d3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[4])
            rank = 9 - parse(Int, splitter[5])

            if black[og_rank, og_col] == "Q" && black[rank, col] == "" &&
                white[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    black[og_rank, og_col] = ""
                    black[rank, col] = "Q"
                end
            end
            
        end

    elseif l == 6
        if splitter[4] == "x" # Nf2xd3
            og_rank = 9 - parse(Int, splitter[3])
            og_col = convert_file(splitter[2])

            col = convert_file(splitter[5])
            rank = 9 - parse(Int, splitter[6])

            if black[og_rank, og_col] == "Q" && white[rank, col] != "" &&
                black[rank, col] == ""
                if line_of_sight(piece_interception(rank,col,og_rank,og_col)) == 0

                    black[og_rank, og_col] = ""
                    black[rank, col] = "Q"
                    white[rank, col] = ""
                end
            end

        end
    end

end


"""
queen_surround()

find all spots the queen could jump into the square from
"""
function queen_surround(rank, col)
    return [rook_surround(rank, col); bisharp_surround(rank,col)]
    
end


"""
white_king()

Move the white king.
"""
function white_king(move::String)
    splitter = split(move, "")
    
    # position = (rank,col) want to see if king is directly adjacent to this

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])
        if white_check(rank, col) == 0
            for i ∈ king_surround(rank,col)
                if white[i[1],i[2]] == "K" && black[rank, col] == "" && white[rank, col] == ""
                    white[i[1], i[2]] = ""
                    white[rank,col] = "K"
                    w_king[1] = rank
                    w_king[2] = col
                    break
                end
            end
        end
    end


    if l == 4
        col = convert_file(splitter[3])
        rank = 9 - parse(Int, splitter[4])

        if white_check(rank, col) == 0
            for i ∈ king_surround(rank,col)
                if white[i[1], i[2]] == "K" && black[rank, col] != "" && white[rank, col] == ""
                    white[i[1], i[2]] = ""
                    white[rank,col] = "K"
                    black[rank,col] = ""
                    w_king[1] = rank
                    w_king[2] = col
                    break
                end
            end
        end
    end

end


"""
black_king()

Move the black king.
"""
function black_king(move::String)
    splitter = split(move,"")
    
    # position = (rank,col) want to see if king is directly adjacent to this

    l = length(move)

    if l == 3
        col = convert_file(splitter[2])
        rank = 9 - parse(Int, splitter[3])

        if black_check(rank, col) == 0
            for i ∈ king_surround(rank,col)
                if black[i[1],i[2]] == "K" && white[rank,col] == "" && black[rank,col] == ""
                    black[i[1], i[2]] = ""
                    black[rank,col] = "K"
                    b_king[1] = rank
                    b_king[2] = col
                    break
                end
            end
        end
    end


    if l == 4
        col = convert_file(splitter[3])
        rank = 9 - parse(Int, splitter[4])

        if black_check(rank,col) == 0
            for i ∈ king_surround(rank,col)
                if black[i[1],i[2]] == "K" && white[rank,col] != "" && black[rank,col] == ""
                    black[i[1], i[2]] = ""
                    black[rank,col] = "K"
                    white[rank,col] = ""
                    b_king[1] = rank
                    b_king[2] = col
                    break
                end
            end
        end
    end

end


"""
king_surround()

spaces that the king could come from 
"""
function king_surround(rank::Int,col::Int)
    s_rank = [rank]
    if rank - 1 != 0
        append!(s_rank, rank - 1)
    end
    if rank + 1 != 9
        append!(s_rank, rank + 1)
    end

    s_col = [col]
    if col - 1 != 0
        append!(s_col, col - 1)
    end
    if col + 1 != 9
        append!(s_col, col + 1)
    end

    indices = []

    for i ∈ s_rank
        for j ∈ s_col
            if [i,j] != [rank,col]
                append!(indices, [[i,j]])
            end
        end
    end

    return indices
    
end


"""
white_castle()

Castle for white
"""
function white_castle(move::String)
    if w_castle[1] == 0
        if move == "O-O" && w_rrook[1] == 0
            if white[8,6] == "" && white[8,7] == "" &&
                black[8,6] == "" && black[8,7] == ""
                # check function see if king is in check on the [8,5], [8,6], [8,7]
                if white_check(8,5) == 0 && white_check(8,6) == 0 &&
                    white_check(8,7) == 0
                    white[8,5] = ""
                    white[8,7] = "K"
                    white[8,8] = ""
                    white[8,6] = "R"
                    w_castle[1] += 1000

                    w_king[1] = 8
                    w_king[2] = 7

                end
            end
        elseif move == "O-O-O" && w_lrook[1] == 0
            if white[8,4] == "" && white[8,3] == "" && white[8,2] == ""
                black[8,4] == "" && black[8,3] == "" && black[8,2] == ""
                if white_check(8,5) == 0 && white_check(8,4) == 0 &&
                    white_check(8,3) == 0
                    white[8,5] = ""
                    white[8,3] = "K"
                    white[8,1] = ""
                    white[8,4] = "R"
                    w_castle[1] += 1000

                    w_king[1] = 8
                    w_king[2] = 3
                end

            end
        end

    end
end


"""
black_castle()

Castle for black
"""
function black_castle(move::String)
    if b_castle[1] == 0
        if move == "O-O" && b_rrook[1] == 0
            if white[1,6] == "" && white[1,7] == "" &&
                black[1,6] == "" && black[1,7] == ""
                # check function see if king is in check on the [8,5], [8,6], [8,7]
                if black_check(1,5) == 0 && black_check(1,6) == 0 &&
                    black_check(1,7) == 0
                    black[1,5] = ""
                    black[1,7] = "K"
                    black[1,8] = ""
                    black[1,6] = "R"
                    b_castle[1] += 1000

                    b_king[1] = 1
                    b_king[2] = 7
                end
            end
        elseif move == "O-O-O" && b_lrook[1] == 0
            if white[1,4] == "" && white[1,3] == "" && white[1,2] == ""
                black[1,4] == "" && black[1,3] == "" && black[1,2] == ""
                if black_check(1,5) == 0 && black_check(1,4) == 0 &&
                    black_check(1,3) == 0
                    black[1,5] = ""
                    black[1,3] = "K"
                    black[1,1] = ""
                    black[1,4] = "R"
                    b_castle[1] += 1000

                    b_king[1] = 1
                    b_king[2] = 3
                end

            end
        end

    end
end


"""
white_check()

See if the white king is in check on those squares
"""
function white_check(rank, col)

    n_squares = knight_surround(rank, col)
    n_len = length(n_squares)
    check = 0

    if n_len != 0
        for i ∈ n_squares
            if black[i[1], i[2]] == "N"
                check += 1
                break
            end
        end
    end


    if check == 0

        b_squares = bisharp_surround(rank, col)
        b_len = length(b_squares)
        if b_len != 0
            for i ∈ b_squares
                if black[i[1], i[2]] == "B" || black[i[1], i[2]] == "Q"
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                        check += 1
                        break
                    end
                end
            end
        end

    end

    if check == 0
        r_squares = rook_surround(rank, col)
        r_len = length(r_squares)
        if r_len != 0
            for i ∈ r_squares
                if black[i[1], i[2]] == "R" || black[i[1], i[2]] == "Q"
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                        check += 1
                        break
                    end
                end
            end
        end
    end

    return check
end


"""
black_check()

See if the black king is in check on those squares
"""
function black_check(rank, col)

    n_squares = knight_surround(rank, col)
    n_len = length(n_squares)
    check = 0

    if n_len != 0
        for i ∈ n_squares
            if white[i[1], i[2]] == "N"
                check += 1
                break
            end
        end
    end


    if check == 0

        b_squares = bisharp_surround(rank, col)
        b_len = length(b_squares)
        if b_len != 0
            for i ∈ b_squares
                if white[i[1], i[2]] == "B" || white[i[1], i[2]] == "Q"
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                        check += 1
                        break
                    end
                end
            end
        end

    end

    if check == 0
        r_squares = rook_surround(rank, col)
        r_len = length(r_squares)
        if r_len != 0
            for i ∈ r_squares
                if white[i[1], i[2]] == "R" || white[i[1], i[2]] == "Q"
                    if line_of_sight(piece_interception(rank,col,i[1],i[2])) == 0
                        check += 1
                        break
                    end
                end
            end
        end
    end

    return check
end





######################### test boards ####################################


white = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "B" "" "B" "" "N" "" "";
    "" "" "" "" "" "" "" "";
    "" "B" "" "B" "" "N" "" "";
    "p" "p" "p" "p" "p" "p" "p" "p";
    "" "N" "B" "Q" "K" "B" "N" "R"
]



black = ["R" "N" "B" "Q" "K" "B" "N" "";
"p" "p" "p" "p" "p" "p" "p" "p";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "p" "p" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" ""
]








############################# obselete code (redone better) ######################

"""
w_pawn()

Move white pawn, and make sure of en passant rule 
"""
function w_pawn(move::String)
    splitter = split(move,"")
    col = convert_file(splitter[1])

    l = length(move)

    if l == 2
        rank = 9 - parse(Int,splitter[2])

        for i ∈ check_pawn_position(rank)
            if white[i, col] == "p" || white[i,col] == "pe"
                if i > rank && i - rank == 1 && 
                    black[rank,col] == "" && white[rank,col] == ""
                        white[i,col] = ""
                        white[rank,col] = "p"
                elseif i > rank && i - rank == 2 && i == 7 && 
                    black[rank,col] == "" && black[rank,col + 1] == "" &&
                    white[rank,col] == "" && white[rank,col + 1] == ""
                        white[i,col] = ""
                        white[rank,col] = "pe"
                end
            end
        end


    elseif l == 4
        if splitter[2] == "8"
            rank = 9-parse(Int,splitter[2])
            #print("yes")
            for i ∈ check_pawn_position(rank)
                if white[i, col] == "p"
                    if i > rank && i - rank == 1 && 
                        black[rank,col] == "" && white[rank,col] == ""
                            white[i,col] = ""
                            white[rank,col] = string(splitter[4])
                    end
                end
            end


        elseif splitter[2] == "x"
            rank = 9-parse(Int,splitter[4])
            take_file = convert_file(splitter[3])


            for i ∈ check_pawn_position(rank)
                if white[i, col] == "p" &&
                    black[rank,take_file] != "" &&
                    i > rank && i - rank == 1
                        white[i,col] = ""
                        white[rank,take_file] = "p"
                        black[rank,take_file] = ""
                        print("yes")

                elseif white[i, col] == "pe" &&
                    black[rank,take_file] != "" &&
                    i > rank && i - rank == 1
                        white[i,col] = ""
                        white[rank,take_file] = "p"
                        black[rank,take_file] = ""
                        print("yes")

                elseif white[i, col] == "p" && white[rank,take_file] == "" &&
                    black[rank + 1,take_file] == "pe" &&
                    i > rank && i - rank == 1
                        white[i,col] = ""
                        white[rank,take_file] = "p"
                        black[rank + 1,take_file] = ""
                        print("yes")
                end
            end
            


        end

    elseif l == 6
        rank = 9-parse(Int,splitter[4])
        take_file = convert_file(splitter[3])
        
        for i ∈ check_pawn_position(rank)
            if white[i, col] == "p" && black[rank,take_file] != "" &&
                i > rank && i - rank == 1
                    white[i,col] = ""
                    white[rank,take_file] = string(splitter[6])
                    black[rank,take_file] = ""
                
            end
        end
        


    end


end

"""
b_pawn()

Move black pawn, and make sure of en passant rule 
"""
function b_pawn(move::String)
    splitter = split(move,"")
    col = convert_file(splitter[1])

    l = length(move)

    if l == 2
        rank = 9 - parse(Int,splitter[2])

        for i ∈ check_pawn_position(rank)
            if black[i, col] == "p" || black[i,col] == "pe"
                if i < rank && i - rank == -1 && 
                    black[rank,col] == "" && white[rank,col] == ""
                        black[i,col] = ""
                        black[rank,col] = "p"
                elseif i < rank && i - rank == -2 && i == 2 && 
                    black[rank,col] == "" && black[rank,col - 1] == "" &&
                    white[rank,col] == "" && white[rank,col - 1] == ""
                        black[i,col] = ""
                        black[rank,col] = "pe"
                end
            end
        end


    elseif l == 4
        if splitter[2] == "1"
            rank = 9-parse(Int,splitter[2])
            for i ∈ check_pawn_position(rank)
                if black[i, col] == "p"
                    if i < rank && i - rank == -1 && 
                        black[rank,col] == "" && white[rank,col] == ""
                            black[i,col] = ""
                            black[rank,col] = string(splitter[4])
                    end
                end
            end


        elseif splitter[2] == "x"
            rank = 9-parse(Int,splitter[4])
            take_file = convert_file(splitter[3])


            for i ∈ check_pawn_position(rank)
                if black[i, col] == "p" &&
                    white[rank,take_file] != "" &&
                    i < rank && i - rank == -1
                        black[i,col] = ""
                        black[rank,take_file] = "p"
                        white[rank,take_file] = ""
                    

                elseif black[i, col] == "pe" &&
                    white[rank,take_file] != "" &&
                    i < rank && i - rank == -1
                        black[i,col] = ""
                        black[rank,take_file] = "p"
                        white[rank,take_file] = ""

                elseif black[i, col] == "p" && black[rank,take_file] == "" &&
                    white[rank - 1,take_file] == "pe" &&
                    i < rank && i - rank == -1
                        black[i,col] = ""
                        black[rank,take_file] = "p"
                        white[rank - 1,take_file] = ""
                        print("yes")


                end
            end
            


        end

    elseif l == 6
        rank = 9-parse(Int,splitter[4])
        take_file = convert_file(splitter[3])
        
        for i ∈ check_pawn_position(rank)
            if black[i, col] == "p" && white[rank,take_file] != "" &&
                i < rank && i - rank == -1
                    black[i,col] = ""
                    black[rank,take_file] = string(splitter[6])
                    white[rank,take_file] = ""
                
            end
        end
        


    end


end


"""
check_pawn_position()

indices 2-7 except future location of pawn
"""
function check_pawn_position(conv::Int)
    if conv == 1 || conv == 8
        return [2, 3, 4, 5, 6, 7]
    elseif conv ∈ 2:7
        indicies = [2, 3, 4, 5, 6, 7]
        deleteat!(indicies, conv-1)
        return indicies
    end
end