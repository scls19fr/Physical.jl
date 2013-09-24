include("Units.jl")
module Quantitys
using Units
# adding methods to:
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==, getindex, setindex!, size, ndims, endof, length, isapprox

typealias QValue  Union(Number, AbstractArray)
abstract HasUnits

type Quantity{T<:QValue} <: HasUnits
    value::T
    unit::Unit
end
Quantity_(x::QValue, y::Unit) = y == Unitless ? x : Quantity(x,y) # return a normal julia object when unitless
Quantity(x::Quantity, y::Unit) = error("Quantity{Quantity} not allowed")
QUnit(x::String) = Quantity(1,Unit(x))

*{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value*y.value, x.unit*y.unit)
*(x::Quantity, y::QValue) = Quantity_(x.value*y, x.unit)
*(x::QValue, y::Quantity) = y*x
.*{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value.*y.value, x.unit*y.unit)
.*(x::Quantity, y::QValue) = Quantity_(x.value.*y, x.unit)
.*(x::QValue, y::Quantity) = y.*x
/{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value/y.value, x.unit/y.unit)
/(x::Quantity, y::QValue) = Quantity_(x.value/y, x.unit)
/(x::QValue, y::Quantity) = y/x
./{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value./y.value, x.unit./y.unit)
./(x::Quantity, y::QValue) = Quantity_(x.value./y, x.unit)
./(x::QValue, y::Quantity) = y./x
+{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value+y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value-y.value, x.unit) : error("x=$x cannot subtract with y=$y because units are not equal")
-{T}(x::Quantity{T}) = Quantity_(-x.value, x.unit)
^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
^{T}(x::Quantity{T}, y::Number) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
.^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value.^convert(FloatingPoint,y), x.unit.^convert(FloatingPoint,y))
.^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value.^convert(FloatingPoint,y), x.unit.^convert(FloatingPoint,y))
.^{T}(x::Quantity{T}, y::Number) = Quantity_(x.value.^convert(FloatingPoint,y), x.unit.^convert(FloatingPoint,y))
isapprox(x::Quantity, y::Quantity) = x.unit == y.unit && isapprox(x.value, y.value)
for f in (:(==), :<, :>, :>=, :<=, :.!=, :(.==), :.<, :.>, :.>=, :.<=, :.!=, :isapprox)
    @eval ($f)(x::Quantity, y::Quantity) = x.unit == y.unit && ($f)(x.value,y.value)
end
sqrt(x::Quantity) = Quantity_(sqrt(x.value), x.unit)
getindex(x::Quantity, y...) = Quantity_(getindex(x.value, y...),x.unit)
setindex!(x::Quantity, y::Quantity, z...) = x.unit == y.unit ? setindex!(x.value, y.value, z...) : error("x[z]=y requires same units for x and y, x.unit=$(x.unit), y.unit=$(y.unit)")
setindex!(x::Quantity, y, z...) = error("x[z]=y reqires same units, x.unit=$(x.unit), y has no units. use x[z] = y*same_units or x.value[z] = y instead")
size(x::Quantity) = size(x.value)
ndims(x::Quantity) = ndims(x.value)
endof(x::Quantity) = endof(x.value)
length(x::Quantity) = length(x.value)

function show{T}(io::IO, x::Quantity{T})
    show(io, x.value)
    print(io, " ")
    show(io, x.unit)
end

export QUnit

end #end module






