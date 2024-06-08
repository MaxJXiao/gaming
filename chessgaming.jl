###############

turn = [0]
parity = [1]

"""
run_chess()

Run a game of Chess which requires user input
"""
function run_chess()
        
    turn[1] = 0
    parity[1] = 1

    start = false

    board_reset()


    while turn[1] != 10

        draw_white_pgn()
        display(whitepgn)

        if turn[1] == 0

            while start != true
                print("Let's go? ")
                go = readline()

                println()
                start = true
            end

            turn[1] += 1
        end



        if white_state() == -200 || white_state() == 0
            print("White: ")
            print(white_state())
            break

        end

        if parity[1] == 1

            white_live()

            parity[1] *= -1

        end

        draw_black_pgn()
        display(blackpgn)


        if black_state() == -200 || black_state() == 0
            print("Black: ")
            print(black_state())
            break
            
        end

        if parity[1] == -1

            black_live()

            parity[1] *= -1

        end

        turn[1] += 1

    end

end




"""
continue_chess()

Continue current game of chess if it breaks for some reason
"""
function continue_chess(turn::Vector{Int}, parity::Vector{Int})

    start = false

    while turn[1] != 10

        draw_white_pgn()
        display(whitepgn)

        if start == false

            while start != true
                print("Let's continue? ")
                go = readline()

                println()
                start = true
            end

        end



        if white_state() == -200 || white_state() == 0
            print("White: ")
            print(white_state())
            break

        end

        if parity[1] == 1

            white_live()

            parity[1] *= -1

        end

        draw_black_pgn()
        display(blackpgn)


        if black_state() == -200 || black_state() == 0
            print("Black: ")
            print(black_state())
            break
            
        end

        if parity[1] == -1

            black_live()

            parity[1] *= -1

        end

        turn[1] += 1

    end

end



function white_live()

    w_copying = copy(white)

    print("White's move: ")

    count = 0

    white_text = [""]

    while w_copying == white

        if count != 0
            println("White's move: $white_text was not legal.")
            println("White's move: ")
        end

        whites = readline()

        white_text[1] = whites

        white_move(whites) 

        println()

        count += 1

    end

end

function black_live()

    b_copying = copy(black)

    print("Black's move: ")

    count = 0

    black_text = [""]

    while b_copying == black

        if count != 0
            println("Black's move: $black_text was not legal.")
            println("Black's move: ")
        end

        blacks = readline()

        black_text[1] = blacks

        black_move(blacks)

        println()

        count += 1

    end

end


"""
white_state()

For white, check if stalemate, checkmate or normal position
"""
function white_state()
    if length(white_legal()) == 0
        if white_check(w_king[1], w_king[2]) == 1
            return -200
        elseif white_check(w_king[1], w_king[2]) == 0
            return 0
        end
    else
        return 1
    end
end


"""
black_state()

For black, check if stalemate, checkmate or normal position
"""
function black_state()
    if length(black_legal()) == 0
        if black_check(b_king[1], b_king[2]) == 1
            return -200
        elseif black_check(b_king[1], b_king[2]) == 0
            return 0
        end
    else
        return 1
    end
end

