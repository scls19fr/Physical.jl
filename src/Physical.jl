include("Quantities.jl")
module Physical
using Quantities
export as, asbase, BaseUnit, DerivedUnit, Prefix
export Uncertain

# looks in Physical/data and loads files in alpabetical order
# stores load order in Physica.loaded_files for debugging
function load_unit_system(loaddir::AbstractString)
	Quantities.reset_unit_system()
	Quantities.PUnits.reset_prefix_system()
	datapath = normpath(dirname(Base.source_path()), "../data/$(loaddir)")
	global loaded_files = sort(readdir(datapath))
	for filename in loaded_files
		include(joinpath(datapath,filename))
	end
end
include(normpath(dirname(Base.source_path()), "../data/what_to_load.jl"))

end # end module
