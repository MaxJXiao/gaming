using Luxor

# 600 x 600 window with white background, centre is (0,0)
# (0,-300) top, (0, 300) bottom

# horizontal line
@draw line(Point(-250,0), Point(250,0), :stroke)

# vertical line
@draw line(Point(0,-250), Point(0,250), :stroke)

# diagonal line
@draw line(Point(-250, -250), Point(250,250), :stroke)

# draw diagonal arrow, arrow head at second point
@draw arrow(Point(-250, -250), Point(250,250))

# draw circle
@draw circle(Point(0,0), 200, :stroke)

# draw box
@draw box(Point(0,0), 500, 300, :stroke) # centre, width, height

# draw dashed circle
@draw begin
    setdash("dot")
    circle(Point(0,0), 200, :stroke) # set a different stroke pattern
end

@draw begin
    setdash("dot")
    arrow(Point(-250,0), Point(250,0))
    arrow(Point(0,-250),Point(0,250))
    circle(Point(0,0), 200, :stroke)
    box(Point(0,0), 400 , 400, :stroke)

end

function guidelines()
    setdash("dot")
    arrow(Point(-250,0), Point(250,0))
    arrow(Point(0,-250),Point(0,250))
    circle(Point(0,0), 200, :stroke)
    box(Point(0,0), 400 , 400, :stroke)
    setdash("solid")
end

@draw guidelines()


# draw triangle

@draw begin
    guidelines()
    ngon(Point(0,0), 200, 3, -π/2, :stroke)
end

# square

@draw begin
    guidelines()
    ngon(Point(0,0), 200, 4, -π/4, :stroke)
end

# pentagon

@draw begin
    guidelines()
    ngon(Point(0,0), 200, 5, -π/2, :stroke)
end

# ellipse

@draw begin
    guidelines()
    ellipse(Point(0,0), 400, 200, :stroke) # width and height
end

# draw arc / semicircle

@draw begin
    guidelines()
    arc2r(Point(0,0), Point(0,-200), Point(0,200), :stroke)
end

@draw begin
    guidelines()
    arc2r(Point(0,0), Point(-200,0), Point(0,-200), :stroke)
end


########### add text

@draw begin
    guidelines()
    text("Hello, Luxor!")
end

# custom text

@draw begin
    guidelines()
    setfont("Gargi", 48)
    settext(
        "hello Luxor",
        halign = "center", valign = "center" # left, right, top, bottom
    )
end


# color

@draw begin
    guidelines()
    setcolor("red") # default black
    setline(10) # default 2
    circle(Point(0,0), 200, :fill) #stroke
end

@draw begin
    guidelines()
    setcolor("yellow")
    ellipse(Point(0,0), 400, 200, :fill)
    
    setcolor("red")
    setline(10)
    ellipse(Point(0,0), 400, 200, :stroke)

    setcolor("blue")
    setfont("Gargi", 48)
    settext("generic logo",
        halign = "center", valign = "center"
    )
end

# @svg, @png, @pdf, @eps
# saving


@png begin
    guidelines()
    ngon(Point(0,0), 200, 3, -π/2, :stroke)
end 600 600 "triangle.png"

@svg begin
    guidelines()
    ngon(Point(0,0), 200, 3, -π/2, :stroke)
end 600 600 "triangle.svg"
# change fill capacity to make transparent


# draw astroid

@draw begin
    background("antiquewhite")
    guidelines()
    setcolor("darkblue")
    setline(0.5)
    # horizontal and vertical lines

    line(Point(-200,0), Point(200, 0), :stroke)
    line(Point(0,-200), Point(0, 200), :stroke)
    
    # astroid
    for i ∈ 0:10:200
        line(Point(200 - i, 0), Point(0, i + 10), :stroke)
        line(Point(0, 200 - i), Point(-10 - i, 0), :stroke)
        line(Point(-200 + i, 0), Point(0, -10 - i), :stroke)
        line(Point(0, -200 + i), Point(10 + i, 0), :stroke)
    end

end


@svg begin
    background("antiquewhite")
    guidelines()
    setcolor("darkblue")
    setline(0.5)
    # horizontal and vertical lines

    line(Point(-200,0), Point(200, 0), :stroke)
    line(Point(0,-200), Point(0, 200), :stroke)
    
    # astroid
    for i ∈ 0:10:200
        line(Point(200 - i, 0), Point(0, i + 10), :stroke)
        line(Point(0, 200 - i), Point(-10 - i, 0), :stroke)
        line(Point(-200 + i, 0), Point(0, -10 - i), :stroke)
        line(Point(0, -200 + i), Point(10 + i, 0), :stroke)
    end

end 600 600 "asteroid.svg"