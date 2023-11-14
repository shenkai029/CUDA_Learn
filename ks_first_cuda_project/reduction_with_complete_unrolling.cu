#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "common.h"
#include "cuda_common.cuh"

#include "cuda.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void reduction_kernel_complete_unrolling(int* int_array,
	int* temp_array, int size)
{
	int tid = threadIdx.x;

	//element index for this thread
	int index = blockDim.x * blockIdx.x + threadIdx.x;

	//local data pointer
	int* i_data = int_array + blockDim.x * blockIdx.x;

	int active_threads = blockDim.x;

	if (active_threads == 1024 && tid < 512)
		i_data[tid] += i_data[tid + 512], active_threads /= 2;
	__syncthreads();

	if (active_threads == 512 && tid < 256)
		i_data[tid] += i_data[tid + 256], active_threads /= 2;
	__syncthreads();

	if (active_threads == 256 && tid < 128)
		i_data[tid] += i_data[tid + 128], active_threads /= 2;
	__syncthreads();

	if (active_threads == 128 && tid < 64)
		i_data[tid] += i_data[tid + 64], active_threads /= 2;
	__syncthreads();

	if (tid < 32)
	{
		volatile int* vsmem = i_data;
		vsmem[tid] += vsmem[tid + 32];
		vsmem[tid] += vsmem[tid + 16];
		vsmem[tid] += vsmem[tid + 8];
		vsmem[tid] += vsmem[tid + 4];
		vsmem[tid] += vsmem[tid + 2];
		vsmem[tid] += vsmem[tid + 1];
	}

	if (tid == 0)
	{
		temp_array[blockIdx.x] = i_data[0];
	}
}

//int main(int argc, char ** argv)
//{
//	printf("Running parallel reduction with complete unrolling kernel \n");
//
//	int size = 1 << 22;
//	int byte_size = size * sizeof(int);
//	int block_size = 1024;
//
//	int * h_input, *h_ref;
//	h_input = (int*)malloc(byte_size);
//
//	initialize(h_input, size, INIT_RANDOM);
//
//	int cpu_result = reduction_cpu(h_input, size);
//
//	dim3 block(block_size);
//	dim3 grid(size / block_size);
//
//	printf("Kernel launch parameters || grid : %d, block : %d \n", grid.x, block.x);
//
//	int temp_array_byte_size = sizeof(int)* grid.x;
//
//	h_ref = (int*)malloc(temp_array_byte_size);
//
//	int * d_input, *d_temp;
//	gpuErrChk(cudaMalloc((void**)&d_input, byte_size));
//	gpuErrChk(cudaMalloc((void**)&d_temp, temp_array_byte_size));
//
//	gpuErrChk(cudaMemset(d_temp, 0, temp_array_byte_size));
//	gpuErrChk(cudaMemcpy(d_input, h_input, byte_size,
//		cudaMemcpyHostToDevice));
//
//	reduction_kernel_complete_unrolling <<< grid, block >> > (d_input, d_temp, size);
//
//	gpuErrChk(cudaDeviceSynchronize());
//	gpuErrChk(cudaMemcpy(h_ref, d_temp, temp_array_byte_size, cudaMemcpyDeviceToHost));
//
//	int gpu_result = 0;
//	for (int i = 0; i < grid.x; i++)
//	{
//		gpu_result += h_ref[i];
//	}
//
//	compare_results(gpu_result, cpu_result);
//
//	gpuErrChk(cudaFree(d_input));
//	gpuErrChk(cudaFree(d_temp));
//	free(h_input);
//	free(h_ref);
//
//	gpuErrChk(cudaDeviceReset());
//	return 0;
//}