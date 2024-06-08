"""
permute()

Find all ways to permute ??
"""
function permute(vec::Vector)
    empty = vec
    arrays = []
    n = length(vec)

    perms = indices(n)
    l = length(perms)

    for i ∈ 1:l 
        add_vector = []
        for j ∈ 1:n
            append!(add_vector, [empty[perms[i][j]] ])
        end
        append!(arrays,[add_vector])
    end

    return arrays


end


"""
indices()

find all indices needed for permuting
"""
function indices(n::Int)
    k = 2
    case = [[1,2],[2,1]]
    case_new = case
    while k != n
        case_old = case_new
        case_new = []
        k += 1
        for i ∈ 1:k 
            for j ∈ 1:length(case_old)
                append!(case_new,[inject(case_old[j],k,i)])
            end
        end
    end

    return case_new
end


"""
inject()

inject something into arrays
"""
function inject(vector::Vector, item::Vector, position::Int)
    if position == 1
        return vcat(item, vector)
    elseif position == length(vector) + 1
        return vcat(vector, item)
    else
        return vcat(vector[1:position - 1], item, vector[position:end])
    end
end
function inject(vector::Vector, item, position::Int)
    x = [item]
    if position == 1
        return vcat(x, vector)
    elseif position == length(vector) + 1
        return vcat(vector, x)
    else
        return vcat(vector[1:position - 1], x, vector[position:end])
    end
end


setup = ["R", "N", "B", "Q", "K", "B", "N", "R"]

unique_setups = unique(permute(setup))

remove_side_king = []

for i ∈ unique_setups
    if i[1] == "K" || i[8] == "K"
    else
        append!(remove_side_king, [i])
    end
end

remove_side_king

rook_each_side = []

for i ∈ remove_side_king
    arrangement = []
    for j ∈ 1:length(i)
        if i[j] == "R"
            append!(arrangement, 1)
        elseif i[j] == "K"
            append!(arrangement, 2)
        end
    end
    if arrangement == [1,2,1]
        append!(rook_each_side, [i])
    end
end

rook_each_side

bisharp_colour_complex = []

for i ∈ rook_each_side
    count = 0
    for j ∈ 1:length(i)
        if i[j] == "B"
            count += j
        end
    end
    if count % 2 == 1
        append!(bisharp_colour_complex, [i])
    end
end



fischer_permutations = bisharp_colour_complex


w_960 = ["" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "" "" "" "" "" "" "" "";
    "p" "p" "p" "p" "p" "p" "p" "p";
    "" "" "" "" "" "" "" ""
]


b_960 = ["" "" "" "" "" "" "" "";
"p" "p" "p" "p" "p" "p" "p" "p";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" "";
"" "" "" "" "" "" "" ""
]

"""
reset_960()

Choose and ready the starting position of chess960.
"""
function reset_960()
    board_reset()
    choice = rand(fischer_permutations, 1)

    for i ∈ 1:8
        w_960[8, i] = string(choice[1][i])
        b_960[1, i] = string(choice[1][i])

        if string(choice[1][i]) == "K"
            w_king[2] = i
            b_king[2] = i
        end
    end

    white .= w_960
    black .= b_960
end