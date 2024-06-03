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

r_black = ["R" "N" "B" "Q" "K" "B" "N" "R";
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
    
end


"""
w_reset()

Reset pieces for white
"""
function w_reset()
    white .= r_white
end

"""
b_reset()

Reset pieces for black
"""
function b_reset()
    black .= r_black
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
piece_identifier()

Figure out which piece the player wants to move.

"""
function piece_identifier()
    
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
function knight_surround(rank,col)
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
        for i ∈ king_surround(rank,col)
            if white[i[1],i[2]] == "K" && black[rank, col] == "" && white[rank, col] == ""
                white[i[1], i[2]] = ""
                white[rank,col] = "K"
            end
        end
    end


    if l == 4
        col = convert_file(splitter[3])
        rank = 9 - parse(Int, splitter[4])

        for i ∈ king_surround(rank,col)
            if white[i[1], i[2]] == "K" && black[rank, col] != "" && white[rank, col] == ""
                white[i[1], i[2]] = ""
                white[rank,col] = "K"
                black[rank,col] = ""
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
        for i ∈ king_surround(rank,col)
            if black[i[1],i[2]] == "K" && white[rank,col] == "" && black[rank,col] == ""
                black[i[1], i[2]] = ""
                black[rank,col] = "K"
            end
        end
    end


    if l == 4
        col = convert_file(splitter[3])
        rank = 9 - parse(Int, splitter[4])
        for i ∈ king_surround(rank,col)
            if black[i[1],i[2]] == "K" && white[rank,col] != "" && black[rank,col] == ""
                black[i[1], i[2]] = ""
                black[rank,col] = "K"
                white[rank,col] = ""
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







white = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "N" "" "" "" "N" "" "";
    "" "" "" "" "" "" "" "";
    "" "N" "" "" "" "N" "" "";
    "p" "p" "p" "p" "p" "p" "p" "p";
    "" "N" "B" "Q" "K" "B" "N" "R"
]



black = ["R" "N" "B" "Q" "K" "B" "N" "";
"p" "p" "p" "p" "p" "p" "p" "p";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "p" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" ""
]








############################# obselete code (redone better)

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