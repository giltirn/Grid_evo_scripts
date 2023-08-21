import sys

class GridCartesian:
    def __init__(self, dimensions, simd_layout, processor_grid):
        dims = len(dimensions)
        self.ldimensions = [None]*dims
        self.rdimensions = [None]*dims
        self.fdimensions = [None]*dims
        self.gdimensions = [None]*dims

        for d in range(dims):
            self.fdimensions[d] = dimensions[d]
            self.gdimensions[d] = self.fdimensions[d]
            
            self.ldimensions[d] = self.gdimensions[d] / processor_grid[d] #local dimensions
            if(self.ldimensions[d] * processor_grid[d] != self.gdimensions[d]):
                print("GridCartesian dimension %d of size %d does not divide evenly over processors %d" % (d,self.gdimensions[d],processor_grid[d]))
                sys.exit(1)
            self.rdimensions[d] = self.ldimensions[d] / simd_layout[d]; #overdecomposition
            if(self.rdimensions[d] * simd_layout[d] != self.ldimensions[d]):
                print("GridCartesian dimension %d of local size %d does not divide evenly over SIMD lanes %d" % (d,self.ldimensions[d],simd_layout[d]))
                sys.exit(1)
                

    def status(self):
        print("Full dimensions",self.fdimensions)
        print("Checkerboarded dimensions",self.gdimensions)
        print("Local dimensions", self.ldimensions)
        print("Local reduced dimensions", self.rdimensions)

class GridRedBlackCartesian:
    def __init__(self, dimensions, simd_layout, processor_grid, checker_dim_mask=[1,1,1,1], checker_dim=0):
        if(checker_dim_mask[checker_dim] != 1):
            print("Checkerboard dimension mask must be enabled for checkerboard direction %d" % checker_dim)
            sys.exit(1)

        dims = len(dimensions)
        self.ldimensions = [None]*dims
        self.rdimensions = [None]*dims
        self.fdimensions = [None]*dims
        self.gdimensions = [None]*dims

        for d in range(dims):
            self.fdimensions[d] = dimensions[d]
            self.gdimensions[d] = self.fdimensions[d]
            
            if (d == checker_dim):
                if(self.gdimensions[d] % 2 != 0):
                    print("Global dimension %d of size %d must be divisible by 2 for checkerboarding" % (d,self.gdimensions[d]))
                    sys.exit(1)
                self.gdimensions[d] = self.gdimensions[d] / 2 #Remove a checkerboard
                print("Checkerboarding: gdimensions[%d] %d -> %d" % (d,self.gdimensions[d]*2,self.gdimensions[d]))
            
            self.ldimensions[d] = self.gdimensions[d] / processor_grid[d] #local dimensions
            if(self.ldimensions[d] * processor_grid[d] != self.gdimensions[d]):
                print("GridCartesian dimension %d of size %d does not divide evenly over processors %d" % (d,self.gdimensions[d],processor_grid[d]))
                sys.exit(1)
            self.rdimensions[d] = self.ldimensions[d] / simd_layout[d]; #overdecomposition
            if(self.rdimensions[d] * simd_layout[d] != self.ldimensions[d]):
                print("GridCartesian dimension %d of local size %d does not divide evenly over SIMD lanes %d" % (d,self.ldimensions[d],simd_layout[d]))
                sys.exit(1)

            if(self.rdimensions[d] == 0):
                print("Reduced dimension in direction %d is zero!" % d)
                sys.exit(1)

            #all elements of a simd vector must have same checkerboard.
            #If Ls vectorised, this must still be the case; e.g. dwf rb5d
            if (simd_layout[d] > 1 and checker_dim_mask[d] == 1):
                if(self.rdimensions[d] % 2 != 0):
                    print("Final reduced dimension in direction %d of size %d must be divisible by 2 to ensure all SIMD lanes have the same checkerboard" % (d,self.rdimensions[d]))
                    sys.exit(1)

    def status(self):
        print("Full dimensions",self.fdimensions)
        print("Checkerboarded dimensions",self.gdimensions)
        print("Local dimensions", self.ldimensions)
        print("Local reduced dimensions", self.rdimensions)




def GridDefaultSimd(dims,nsimd):
    layout = [None]*4
    nn=nsimd;
    for dd in range(dims):
        d=dims-1-dd
        if( nn>=2 ):
                layout[d]=2
                nn/=2
        else:
                layout[d]=1
                       
    return layout








gen_simd_width = 64
mpi_layout = [4,2,2,16]
lattice = [40,40,40,64]


dims = 4
sizeof_double = 8
sizeof_float = 4


Nsimd_ComplexF = gen_simd_width/2/sizeof_float
Nsimd_ComplexD = gen_simd_width/2/sizeof_double

simd_layout_F = GridDefaultSimd(dims, Nsimd_ComplexF)
simd_layout_D = GridDefaultSimd(dims, Nsimd_ComplexD)

print("Lattice",lattice)
print("MPI layout",mpi_layout)

print("SIMD layout ComplexF",simd_layout_F)
print("SIMD layout ComplexD",simd_layout_D)

print("ComplexD full grid:")
cart_D = GridCartesian(lattice, simd_layout_D, mpi_layout)
cart_D.status()

print("ComplexF full grid:")
cart_F = GridCartesian(lattice, simd_layout_F, mpi_layout)
cart_F.status()

print("ComplexD checkerboard grid:")
cbcart_D = GridRedBlackCartesian(lattice, simd_layout_D, mpi_layout)
cbcart_D.status()

print("ComplexF checkerboard grid:")
cbcart_F = GridRedBlackCartesian(lattice, simd_layout_F, mpi_layout)
cbcart_F.status()
