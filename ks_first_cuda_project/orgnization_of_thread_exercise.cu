#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void print_details_3d()
{
	printf("threadIdx.x : %d, threadIdx.x : %d, threadIdx.z : %d, blockIdx.x : %d, blockIdx.y : %d, blockIdx.z : %d, blockDim.x : %d, blockDim.y : %d, gridDim.x : %d, gridDmi.y : %d \n",
		threadIdx.x, threadIdx.y, threadIdx.z, blockIdx.x, blockIdx.y, blockIdx.z, blockDim.x, blockDim.y, gridDim.x, gridDim.y);
}

//int main()
//{
//	int nx, ny, nz;
//	nx = 8;
//	ny = 8;
//	nz = 8;
//	dim3 block(4, 4, 4);
//	dim3 grid(nx / block.x, ny / block.y, nz / block.z);
//
//	print_details_3d << <grid, block >> > ();
//	cudaDeviceSynchronize();
//
//	cudaDeviceReset();
//	return 0;
//}