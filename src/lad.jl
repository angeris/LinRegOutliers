"""

    lad(setting; starting_betas = nothing)

Perform Least Absolute Deviations regression for a given regression setting.

# Arguments
- `setting::RegressionSetting`: RegressionSetting object with a formula and dataset.
- `starting_betas::Array{Float64,1}`: Starting values of parameter estimations that fed to local search optimizer.


# Examples
```julia-repl
julia> reg0001 = createRegressionSetting(@formula(calls ~ year), phones);
julia> lad(reg0001)
Dict{Any,Any} with 2 entries:
  "betas"     => [-57.3269, 1.19155]
  "residuals" => [2.14958, 1.25803, 0.0664872, 0.0749413, -0.416605, -0.90815, -1.2997, -1.79124,…

```

"""
function lad(setting::RegressionSetting; starting_betas=nothing)
    X = designMatrix(setting)
    Y = responseVector(setting)
    n, p = size(X)

    if starting_betas isa Nothing
        starting_betas = zeros(Float64, p)
    end

    function goal(betas::Array{Float64,1})::Float64
        sum(abs.(Y .- X * betas))
    end

    optim_result = optimize(goal, starting_betas, NelderMead())
    betas = optim_result.minimizer 
    residuals = Y .- X * betas

    result = Dict()
    result["betas"] = optim_result.minimizer
    result["residuals"] = residuals

    return result
end