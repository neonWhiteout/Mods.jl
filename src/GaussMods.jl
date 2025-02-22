import Base: real, imag, reim, conj

export GaussMod


struct GaussMod{N,T} <: AbstractMod
    val::T
end

# type casting
GaussMod{N,T}(x::Mod{N,T2}) where {T,N,T2} = GaussMod{N,T}(T(x.val))
GaussMod{N,T}(x::Mod{N,T}) where {T,N} = x
GaussMod(x::AbstractMod) = GaussMod{modulus(x)}(value(x))


mod(z::Complex{<:Integer}, n::Integer) = Complex(mod(real(z), n), mod(imag(z), n))

"""
    GaussMod{N}(a)
Create a new modular number with modulus `N` and value `a`.
"""
function GaussMod{N}(x::Union{Complex,Integer}) where {N}
    @assert N isa Integer && N > 1 "modulus must be an integer and at least 2"
    @assert N <= typemax(Int) "modulus is too large"
    v = Complex{Int}(mod(x, N))
    GaussMod{Int(N),Complex{Int}}(v)
end

GaussMod{N}(x::Mod{N}) where {N} = GaussMod{N}(value(x), 0)
GaussMod(x::GaussMod) = x
Mod(x::GaussMod) = x
Mod{N}(x::GaussMod{N}) where {N} = x
GaussMod{N, T}(x::GaussMod{N, T}) where {N, T} = x
GaussMod{N}(x::Integer, y::Integer) where {N} = GaussMod{N}(x + im * y)
GaussMod{N}(x::Rational) where {N} = GaussMod{N}(Mod{N}(x))

function GaussMod{N}(x::Complex{Rational{T}}) where {N,T}
    a = Mod{N}(real(x))
    b = Mod{N}(imag(x))
    return GaussMod{N}(value(a), value(b))
end


function Mod{N}(x::Complex) where {N}
    GaussMod{N}(x)
end

value(x::GaussMod) = x.val
modulus(x::GaussMod{N}) where {N} = N
abs(x::GaussMod) = abs(value(x))


show(io::IO, z::GaussMod{N}) where {N} = print(io, "GaussMod{$N}($(value(z)))")
show(io::IO, ::MIME"text/plain", z::GaussMod{N}) where {N} = show(io, z)
