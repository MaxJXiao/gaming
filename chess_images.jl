using FileIO , ImageShow


img_white = joinpath(@__DIR__, "images", "chess", "boardwhite_resized.png")
white_board = FileIO.load(img_white)

img_wpawn = joinpath(@__DIR__, "images", "chess", "white-pawn.png")
wpawn = FileIO.load(img_wpawn)

img_wknight = joinpath(@__DIR__, "images", "chess", "white-nightrd.png")
wknight = FileIO.load(img_wknight)

img_wbisharp = joinpath(@__DIR__, "images", "chess", "white-bishop.png")
wbisharp = FileIO.load(img_wbisharp)

img_wrook = joinpath(@__DIR__, "images", "chess", "white-rook.png")
wrook = FileIO.load(img_wrook)

img_wqueen = joinpath(@__DIR__, "images", "chess", "white-queen.png")
wqueen = FileIO.load(img_wqueen)

img_wking = joinpath(@__DIR__, "images", "chess", "white-king.png")
wking = FileIO.load(img_wking)



img_black = joinpath(@__DIR__, "images", "chess", "boardblack_resized.png")
black_board = FileIO.load(img_black)

img_bpawn = joinpath(@__DIR__,"images", "chess", "black-pawn.png")
bpawn = FileIO.load(img_bpawn)

img_bknight = joinpath(@__DIR__, "images", "chess", "black-nightrd.png")
bknight = FileIO.load(img_bknight)

img_bbisharp = joinpath(@__DIR__, "images", "chess", "black-bishop.png")
bbisharp = FileIO.load(img_bbisharp)

img_brook = joinpath(@__DIR__, "images", "chess", "black-rook.png")
brook = FileIO.load(img_brook)

img_bqueen = joinpath(@__DIR__, "images", "chess", "black-queen.png")
bqueen = FileIO.load(img_bqueen)

img_bking = joinpath(@__DIR__, "images", "chess", "black-king.png")
bking = FileIO.load(img_bking)


im_bisharp = joinpath(@__DIR__, "images", "chess", "bisharp (copy).png")
litbisharp = FileIO.load(im_bisharp)

im_shiny_bisharp = joinpath(@__DIR__, "images", "chess", "shinybisharp (copy).png")
litshinybisharp = FileIO.load(im_shiny_bisharp)




############################################################################


simon = wpawn[1,1]
says = litbisharp[1,1]


white_board = FileIO.load(img_white)
whitepgn = copy(white_board);

black_board = FileIO.load(img_black)
blackpgn = copy(black_board);


function reset_white_board()
    whitepgn .= copy(white_board)
end

function reset_black_board()
    blackpgn .= copy(black_board)
end


"""
Show not to use the transparent part of image

for i ∈ 1:128
    for j ∈ 1:128
        if wpawn[i,j] == simon
        else
            whitepgn[i,j] = wpawn[i,j]
        end
    end
end
"""

"""
draw_white_pgn()

Use the white and black boards to make a complete image from the white side
"""
function draw_white_pgn()

    reset_white_board()

    for i ∈ 1:8
        for j ∈ 1:8


            if white[i,j] == "p" || white[i,j] == "pe"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wpawn[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = wpawn[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "N"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wknight[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = wknight[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "B"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if litbisharp[m, n] == says
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = litbisharp[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "R"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wrook[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = wrook[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "Q"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wqueen[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = wqueen[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "K"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wking[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = wking[m,n]
                        end
                    end
                end
            end

            #####################


            if black[i,j] == "p" || black[i,j] == "pe"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bpawn[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = bpawn[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "N"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bknight[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = bknight[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "B"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if litshinybisharp[m, n] == says
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = litshinybisharp[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "R"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if brook[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = brook[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "Q"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bqueen[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = bqueen[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "K"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bking[m, n] == simon
                        else
                            whitepgn[(i - 1)*128 + m, (j - 1)*128 + n] = bking[m,n]
                        end
                    end
                end
            end

        end
    end

    
end

"""
draw_black_pgn()

Use the white and black boards to make a complete image from the black side
"""
function draw_black_pgn()

    reset_black_board()

    for i ∈ 1:8
        for j ∈ 1:8


            if white[i,j] == "p" || white[i,j] == "pe"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wpawn[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = wpawn[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "N"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wknight[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = wknight[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "B"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if litbisharp[m, n] == says
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = litbisharp[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "R"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wrook[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = wrook[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "Q"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wqueen[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = wqueen[m,n]
                        end
                    end
                end
            end

            if white[i,j] == "K"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if wking[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = wking[m,n]
                        end
                    end
                end
            end

            #####################


            if black[i,j] == "p" || black[i,j] == "pe"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bpawn[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = bpawn[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "N"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bknight[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = bknight[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "B"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if litshinybisharp[m, n] == says
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = litshinybisharp[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "R"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if brook[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = brook[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "Q"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bqueen[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = bqueen[m,n]
                        end
                    end
                end
            end

            if black[i,j] == "K"
                for m ∈ 1:128
                    for n ∈ 1:128
                        if bking[m, n] == simon
                        else
                            blackpgn[(8 - i)*128 + m, (8 - j)*128 + n] = bking[m,n]
                        end
                    end
                end
            end

        end
    end

    
end

