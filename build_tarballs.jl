# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "gmsh"
version = v"4.1.5"

# Collection of sources required to build Gmsh
sources = [
    "http://gmsh.info/src/gmsh-4.1.5-source.tgz" =>
    "654d38203f76035a281006b77dcb838987a44fd549287f11c53a1e9cdf598f46",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd gmsh-4.1.5-source
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
    ExecutableProduct(prefix, "gmsh", :gmsh)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

