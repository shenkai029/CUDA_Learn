#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void print_details()
{
	printf("threadIdx.x : %d, threadIdx.x : %d, threadIdx.z : %d, blockDim.x : %d, blockDim.y : %d, gridDim.x : %d, gridDmi.y : %d \n",
		threadIdx.x, threadIdx.y, threadIdx.z, blockDim.x, blockDim.y, gridDim.x, gridDim.y);
}

//int main()
//{
//	int nx, ny;
//	nx = 16;
//	ny = 16;
//	dim3 block(8, 8);
//	dim3 grid(nx / block.x, ny / block.y);
//
//	print_details << <grid, block >> > ();
//	cudaDeviceSynchronize();
//
//	cudaDeviceReset();
//	return 0;
//}