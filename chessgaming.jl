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
run_auto_chess()

Run a game of chess completely randomly
"""
function run_auto_chess(total_turns::Int)
    
    board_reset()

    for i ∈ 1:total_turns
    
        draw_white_pgn()
        display(whitepgn)

        sleep(1)

        white_random_move()

        draw_white_pgn()
        display(whitepgn)

        sleep(1)

        draw_black_pgn()
        display(blackpgn)

        sleep(1)

        black_random_move()

        draw_black_pgn()
        display(blackpgn)

        sleep(1)

    end


end




"""
run_auto_chess()

Run a game of chess completely randomly
"""
function run_auto_chess960(total_turns::Int)

    reset_960()

    for i ∈ 1:total_turns
    
        draw_white_pgn()
        display(whitepgn)

        sleep(1)

        white_random_move()

        draw_white_pgn()
        display(whitepgn)

        sleep(1)

        draw_black_pgn()
        display(blackpgn)

        sleep(1)

        black_random_move()

        draw_black_pgn()
        display(blackpgn)

        sleep(1)

    end


end