"""
    token()
Mick Chiggin has
12 Tokens. 1st player picks [1,2,3] tokens, then the 2nd player does the same. 
Whoever takes the last token wins.
"""
function token()
    viable = Set([1,2,3])
    tokencount = 12

    while tokencount > 0
        println("There are $tokencount tokens remaining. Take [1,2,3]?")
        first_answer = 0

        while first_answer ∉ viable
            print("You take: ")
            first_input = parse(Int, readline())
            first_answer += first_input
            println()
            if first_input ∈ viable
                second_choice = 4 - first_input
                println("I take $second_choice tokens.")
                tokencount -= 4
                println()
                println("There are now $tokencount tokens left.")
            else 
                println("Nah dawg, what the hell is $first_input?, pick again.")
                first_answer -= first_input
            end
        end

    end

    if tokencount == 0
        println()
        println("I win douchebag.")
    end
end