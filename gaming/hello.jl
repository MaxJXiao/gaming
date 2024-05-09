# ] activate .
# ] add GameZero
# ] add Colors
# ] add Statistics
# ] dev GameZero
# cd

# using GameZero
# using Colors
# using Statistics
# rungame("hello.jl")

# TextActor(text::String, font_name::String; font_size=24, color=Int[255,255,0,255])

HEIGHT = 1600
WIDTH = 1600
BACKGROUND = colorant"black"

rn = Actor("dvd.png")
rn.pos = (150,150)


x_mov = randn()
y_mov = randn()

text_actor = TextActor("("*string(x_mov)*", "*string(y_mov)*")","gargi")
text_actor.pos = (150,100)



rectangle₁ = Rect(50,100,350,100)
circle₁ = Circle(330,80,20)
i = 0

function draw(g::Game) #need to give it a game object
    draw(rn)
    draw(text_actor)
    draw(circle₁ , colorant"yellow", fill = true)
    draw(rectangle₁, colorant"white", fill = true)
    draw(Line(50+i,100,350+i,100), colorant"green")
end



function update()
    rn.x = rn.x + x_mov
    rn.y = rn.y + y_mov
    text_actor.x = text_actor.x + x_mov
    text_actor.y = text_actor.y + y_mov
    global i
    i += 1
end

