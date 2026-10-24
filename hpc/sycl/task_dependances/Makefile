# Makefile for SYCL Programs

# Compiler and flags
CXX = icpx
CXXFLAGS = -fsycl -fsycl-targets=nvptx64-nvidia-cuda
SRCS = usm_in_order_queue.cpp usm_depends_on.cpp buffer_accessors.cpp
OBJS = $(SRCS:.cpp=)

# Default target: Build all executables
.PHONY: all
all: $(OBJS)

# Rule for building each program
%: %.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

# Run programs sequentially and measure execution time
.PHONY: run
run: $(OBJS)
	@echo "Running usm_in_order_queue..."
	@echo `time srun ./usm_in_order_queue`
	@echo "Running usm_depends_on..."
	@echo `time srun ./usm_depends_on`
	@echo "Running buffer_accessors..."
	@echo `time srun ./buffer_accessors`

# Clean up generated files
.PHONY: clean
clean:
	rm -f $(OBJS)

