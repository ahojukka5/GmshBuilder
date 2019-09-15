# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "gmsh"
version = v"4.4.1"

# Collection of sources required to build Gmsh
sources = [
    "http://gmsh.info/src/gmsh-$version-source.tgz" =>
    "853c6438fc4e4b765206e66a514b09182c56377bb4b73f1d0d26eda7eb8af0dc",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd gmsh-*
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DDEFAULT=0 -DENABLE_BUILD_SHARED=1 -DENABLE_MESH=1 -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc),
    MacOS(:x86_64),
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libgmsh", :libgmsh),
#   ExecutableProduct(prefix, "gmsh", :gmsh)
]

# Dependencies that must be installed before this package can be built
dependencies = [
   "https://github.com/JuliaLinearAlgebra/OpenBLASBuilder/releases/download/v0.3.0-3/build_OpenBLAS.v0.3.0.jl" 
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

