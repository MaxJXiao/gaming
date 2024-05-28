# cd("/home/max/project/gaming")
# using GameZero
# using Colors

# methods(draw) to find the arguments of draw

WIDTH = 600
HEIGHT = 500
BACKGROUND = colorant"#c54245"
tree_green = colorant"#45c542"

word_list = readlines(joinpath(@__DIR__,"word_list.txt")) #@__DIR__ is in current directory of jl file.
word_list = strip.(word_list) # strip removes white spaces from beginning/end of word

word = rand(word_list)
word_array = string.(collect(word))
num_char = length(word)

println(word)

answers = fill(" ", num_char)


letters = string.(collect('a':'z'))
good_letters = Set()
bad_letters = Set()

c_gl = ""
c_bl = ""


state = "playing"


tree_lines = [
((280,300),(320,300)),
((280,300),(280,260)),
((320,300),(320,260)),
((280,260),(200,260)),
((320,260),(400,260)),
((200,260),(300,100)),
((400,260),(300,100)),

]

score = length(tree_lines)


# TextActor(text::String, font_name::String; font_size=24, color=Int[255,255,0,255])

function draw()
    for i ∈ 1:(length(tree_lines)-score)
        draw(Line(tree_lines[i][1]...,tree_lines[i][2]...),tree_green)
    end

    for i ∈ 1:num_char
        draw(Line(50i,450,50i+30,450), colorant"white")
        draw(Line(50i,451,50i+30,451), colorant"white")
        t = TextActor(answers[i],"gargi"; pos = (50i + 10, 400)) #gargi is font in font folder
        draw(t)
    end

    # for i ∈ 1:26
    #     et = TextActor(letters[i],"gargi"; pos = (10+15i,150))
    #     draw(et)
    #     if letters[i] ∈ string.(good_letters)
    #         gt = TextActor(letters[i],"gargi"; color = Int[124,252,0,255], pos = (10+15*i,150))
    #         draw(gt)
    #     elseif letters[i] ∈ string.(bad_letters)
    #         bt = TextActor(letters[i],"gargi"; color = Int[255,0,0,255], pos = (10+15i,150))
    #         draw(bt)
    #     end
    # end


    sc = TextActor("Tries: $score","gargi"; pos = (450,20))
    draw(sc)

    if state == "won"
        st = TextActor("You Won!", "gargi"; pos = (200,220))
        draw(st)
    elseif state == "lost"
        st = TextActor("You have CTE D:","gargi"; pos = (200,220))
        draw(st)
        f_word = TextActor("The word was "*word, "gargi"; pos = (10,90))
        draw(f_word)
    end


    
    gl = TextActor("Success: "*c_gl,"gargi"; color = Int[125,252,0,255], pos = (10,10))
    draw(gl)

    bl = TextActor("Failed: "*c_bl,"gargi"; color = Int[255,0,0,255], pos = (10,40))
    draw(bl)

end


function on_key_down(g,k) # g = game object, k = key object
    global score
    key_pressed = lowercase(string(Char(k)))
    @show "$key_pressed"

    global c_gl
    global c_bl

    if key_pressed ∈ letters && key_pressed ∈ word_array && score != 0
        @show "found $key_pressed in word"
        answers[findall(x->x == key_pressed,word_array)] .= key_pressed
        push!(good_letters,key_pressed)
        c_gl = join(sort(collect(good_letters)))
    else 
        #global used_letters
        if score != 0 && key_pressed ∈ letters && key_pressed ∉ string.(bad_letters)
            score -= 1
            push!(bad_letters,key_pressed)
            c_bl = join(sort(collect(bad_letters)))
        end
    end

    global state
    if score < 1
        state = "lost"
    end
    if !(" " in answers)
        state = "won"
    end
    

    @show bad_letters
    @show good_letters

    

end


#if key_pressed ∈ used_letters
    #print("yes")
#end