# Compiler and flags
CXX = icpx
COMMON_FLAGS = -fsycl -fintelfpga -qactypes
FPGA_BOARD = -Xsboard=p520_hpc_m210h_g3x16
EMULATION_FLAGS = -Xshardware
FPGA_HARDWARE_FLAGS = -Xshardware $(FPGA_BOARD) -DFPGA_HARDWARE
EARLY_IMAGE_FLAGS = -Xshardware -fsycl-link=early $(FPGA_BOARD)
FAST_COMPILE_FLAGS = -Xsfast-compile
REUSE_EXE = -reuse-exe=

# Source and output settings
SRCS = vector_add.cpp
KERNEL_SRCS = kernel.cpp
HOST_SRCS = host.cpp
OBJS = $(SRCS:.cpp=.o)

.PHONY: all clean emulation early_image full_compile fast_recompile

# Default build target (emulation)
all: emulation

# Compile for emulation
emulation:
	$(CXX) $(COMMON_FLAGS) $(SRCS) -o vector_add.fpga_emu

# Generate FPGA early image (with reports)
early_image:
	$(CXX) $(COMMON_FLAGS) $(EARLY_IMAGE_FLAGS) $(SRCS) -o vector_add_report.a

# Full FPGA hardware compilation
full_compile:
	$(CXX) $(COMMON_FLAGS) $(FPGA_HARDWARE_FLAGS) $(SRCS) -o vector_add_report.fpga

# Full FPGA compilation with fast compile option
fast_compile:
	$(CXX) $(COMMON_FLAGS) $(FPGA_HARDWARE_FLAGS) $(FAST_COMPILE_FLAGS) $(SRCS) -o vector_add_fast.fpga

# Reuse existing FPGA image to recompile
fast_recompile:
	$(CXX) $(COMMON_FLAGS) $(FPGA_HARDWARE_FLAGS) $(REUSE_EXE)vector_add.fpga $(SRCS) -o vector_add_reuse.fpga

# Separate host and kernel compilation
separate_compile:
	$(CXX) $(COMMON_FLAGS) $(FPGA_HARDWARE_FLAGS) $(HOST_SRCS) -c -o host.o
	$(CXX) $(COMMON_FLAGS) $(FPGA_HARDWARE_FLAGS) -fsycl-link=image $(KERNEL_SRCS) -o dev_image.a
	$(CXX) $(COMMON_FLAGS) host.o dev_image.a -o fast_recompile.fpga

# Clean all generated files
clean:
	rm -rf *.o *.a *.prj *.fpga *.fpga_emu *.prj
