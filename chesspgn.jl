## going to turn a pgn into a series of images

"""

1. e4 e6 2. Nf3 d5 3. Nc3 Nf6 4. e5 Nfd7 5. d4 c5 6. Bg5 Qb6 7. dxc5 Bxc5 8. Qd2 Bxf2+ 9. Qxf2 Qxb2 10. Kd2 Qxa1 11. Bb5 Qxh1 12. Qc5 Qxg2+ 13. Kc1 Nc6 14. Bxc6 f6 15. exf6 gxf6 16. Bxf6 Kf7 17. Qe7+ Kg6 18. Nh4+ Kh5 19. Nxg2 Nxf6 20. Qxf6 Bd7 21. Bxd7 Raf8 22. Qh4+ Kg6 23. Bxe6 Rf1+ 1-0

"""

pre = ["a" "b" "c" "d" "e" "f" "g" "h" "N" "B" "R" "Q" "K"]

pgn₁ = "1. e4 e6 2. Nf3 d5 3. Nc3 Nf6 4. e5 Nfd7 5. d4 c5 6. Bg5 Qb6 7. dxc5 Bxc5 8. Qd2 Bxf2+ 9. Qxf2 Qxb2 10. Kd2 Qxa1 11. Bb5 Qxh1 12. Qc5 Qxg2+ 13. Kc1 Nc6 14. Bxc6 f6 15. exf6 gxf6 16. Bxf6 Kf7 17. Qe7+ Kg6 18. Nh4+ Kh5 19. Nxg2 Nxf6 20. Qxf6 Bd7 21. Bxd7 Raf8 22. Qh4+ Kg6 23. Bxe6 Rf1+ 1-0"

moves_1 = find_sequence(pgn₁)

white_gif_maker(moves_1)


"""
find_sequence()

find the sequence of moves to feed into the pgn maker.
"""
function find_sequence(pgn::String)
    snake = split(pgn, " ")

    moves = []
    for i ∈ eachindex(snake)
        if string(snake[i][1]) ∈ pre
            if string(snake[i][end]) == "#" || string(snake[i][end]) == "+"
                append!(moves, [string(snake[i][1:end-1])])
            else
                append!(moves, [snake[i]])
            end
        end
    end

    return moves

end






"""
white_gif_maker()

Make pngs to turn into gif later.
"""
function white_gif_maker(sequence::Vector{Any})

    board_reset()

    for i ∈ eachindex(sequence)
        if i % 2 == 1
            white_move(string(sequence[i] ))
        elseif i % 2 == 0
            black_move(string(sequence[i] ))
        end
        draw_white_pgn()
        save(joinpath(@__DIR__, "images", "chess", "png", "$i.png"), whitepgn)
    end
end

"""
black_gif_maker()

Make pngs to turn into gif later.
"""
function black_gif_maker(sequence::Vector{Any})

    board_reset()

    for i ∈ eachindex(sequence)
        if i % 2 == 1
            white_move(string(sequence[i] ))
        elseif i % 2 == 0
            black_move(string(sequence[i] ))
        end
        draw_black_pgn()
        save(joinpath(@__DIR__, "images", "chess", "png", "$i.png"), blackpgn)
    end
end




save(joinpath(@__DIR__, "images", "chess", "png" "$i.png"),white_board)