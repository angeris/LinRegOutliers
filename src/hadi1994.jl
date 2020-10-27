"""
    hadi1994(multivariateData)

Perform Hadi (1994) algorithm for a given multivariate data.

# Arguments
-`multivariate::Array{Float64, 2}`: Multivariate data.

# Examples
```julia-repl
julia> multidata = hcat(hbk.x1, hbk.x2, hbk.x3);

julia> hadi1994(multidata)
Dict{Any,Any} with 3 entries:
  "outliers"              => [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
  "criticial.chi.squared" => 7.81473
  "rth.robust.distance"   => 5.04541
```

# Reference
Hadi, Ali S. "A modification of a method for the dedection of outliers in multivariate samples"
Journal of the Royal Statistical Society: Series B (Methodological) 56.2 (1994): 393-396.
"""
function hadi1994(multivariateData::Array{Float64,2}; alpha=0.05)
    n, p = size(multivariateData)
    h = Int(round((n + p + 1.0) / 2.0))
    cnp = (1 + ((2)/(n-1-3p)) + ((p+1)/(n-p)))^2
    chi_50_quantile = quantile(Chisq(p), 0.50)
    critical_quantile = quantile(Chisq(p), 1 - alpha)
    allindices = collect(1:n)

    meds = coordinatwisemedians(multivariateData)
    Sm = (1.0 / (n - 1.0)) * (multivariateData .- meds')' * (multivariateData .- meds')
    mah0 = diag(mahalanobisSquaredMatrix(multivariateData, meanvector=meds, covmatrix=Sm))
    ordering_indices_mah0 = sortperm(mah0)
    best_indices_mah0 = ordering_indices_mah0[1:h]
    starting_data = multivariateData[best_indices_mah0, :]

    Cv = coordinatwisemedians(starting_data)
    Sv = (1.0 / (h - 1.0)) * (starting_data .- Cv')' * (starting_data .- Cv')
    mah1 = diag(mahalanobisSquaredMatrix(multivariateData, meanvector=Cv, covmatrix=Sv))
    ordering_indices_mah1 = sortperm(mah1)

    r = p + 1
    basic_subset_indices = []
    basic_subset = []
    sorted_mah1 = []
    Cb = []
    Sb = []
    cnpr = 0
    cfactor = 0
    isFullRank = false

    while r < n

        isFullRank = false

        while !isFullRank
            #cnpr = 1 + (r / (n - p))^2.0
            basic_subset_indices = ordering_indices_mah1[1:r]
            basic_subset = multivariateData[basic_subset_indices, :]
            Cb = applyColumns(mean, basic_subset)
            Sb = cov(basic_subset)
            cfactor = cnp * sqrt(sort(mah1)[h]) / chi_50_quantile
            r += 1

            if (det(cfactor * Sb) == 0 && r < n)
                isFullRank = false
            else
                isFullRank = true
            end
        end

        mah1 = diag(mahalanobisSquaredMatrix(multivariateData, meanvector=Cb, covmatrix=(cfactor * Sb)))

        ordering_indices_mah1 = sortperm(mah1)
        basic_subset_indices = ordering_indices_mah1[1:r]

        sorted_mah1 = sort(mah1)
        if sorted_mah1[r] >= critical_quantile
            break
        end
    end

    outlierset = setdiff(allindices, basic_subset_indices)

    result = Dict()
    result["outliers"] = sort(outlierset)
    result["criticial.chi.squared"] = critical_quantile
    result["rth.robust.distance"] = sorted_mah1[r - 1]
    return result
end
