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


setup = ["rook", "knight", "bisharp", "quen", "king", "bisharp", "knight", "rook"]

unique_setups = unique(permute(setup))

remove_side_king = []

for i ∈ unique_setups
    if i[1] == "king" || i[8] == "king"
    else
        append!(remove_side_king, [i])
    end
end

remove_side_king

rook_each_side = []

for i ∈ remove_side_king
    arrangement = []
    for j ∈ 1:length(i)
        if i[j] == "rook"
            append!(arrangement, 1)
        elseif i[j] == "king"
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
        if i[j] == "bisharp"
            count += j
        end
    end
    if count % 2 == 1
        append!(bisharp_colour_complex, [i])
    end
end



fischer_permutations = bisharp_colour_complex
