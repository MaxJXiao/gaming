files = ["a" "b" "c" "d" "e" "f" "g" "h"]


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

white = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "pe" "" "" "";
    "" "" "" "" "" "" "" "";
    "p" "p" "p" "p" "p" "p" "p" "p";
    "R" "N" "B" "Q" "K" "B" "N" "R"
]
w_castling = 1


black = ["R" "N" "B" "Q" "K" "B" "N" "R";
"p" "p" "p" "p" "p" "p" "p" "p";
"" "" "" "" "" "" "" "";
"" "" "" "pe" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" ""
]

b_castling = 1


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


"""
white_pawn()

Move white pawn, and make sure of en passant rule (none yet)
"""
function white_pawn(move::String)
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
black_pawn()

Move black pawn, and make sure of en passant rule (none yet)
"""
function black_pawn(move::String)
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




