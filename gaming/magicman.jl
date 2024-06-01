"""
magic8ball()

The Ball knows all. If all means a yes/no question.
"""
function magic8ball()
    answering = Set([
    "Idk but you certainly have genetic deficiencies in the head",
    "Most definitely",
    "nah man push off",
    "dunno but i could definitely go for some chicken",
    "if you buy me a mick chiggin then i'll make it a yes",
    "da vinky ??",
    "I've consulted the sages and they've said no. And by that, I mean hell no.",
    "Yea bet it all on 37 black",
    "beats me"
    ])
    state = 0
    while state == 0
        println("Ask a yes or no question (blank to exit).")
        print("Your question: ")
        if readline() == ""
            println("Alright, I'm out.")
            state += 1
        else
            println(rand(answering))
            println()
        end
    end

end