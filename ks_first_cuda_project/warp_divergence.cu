#include "cuda.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda_common.cuh"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

__global__ void code_without_divergence()
{
	int gid = blockIdx.x * blockDim.x + threadIdx.x;

	float a, b;
	a = b = 0;

	int warp_id = gid / 32;
	
	if (warp_id % 2 == 0)
	{
		a = 100.0;
		b = 50.0;
	}
	else
	{
		a = 200.0;
		b = 75.0;
	}


}

__global__ void divergence_code()
{
	int gid = blockIdx.x * blockDim.x + threadIdx.x;

	float a, b;
	a = b = 0;

	if (gid % 2 == 0)
	{
		a = 100.0;
		b = 50.0;
	}
	else
	{
		a = 200.0;
		b = 75.0;
	}


}

//int main()
//{
//	printf("\n----------WARP DIVERGENCE EXAMPLE---------- \n\n");
//
//	int size = 1 << 22;
//
//	dim3 block_size(128);
//	dim3 grid_size((size + block_size.x - 1) / block_size.x);
//
//	code_without_divergence << <grid_size, block_size >> > ();
//	cudaDeviceSynchronize();
//
//	divergence_code << <grid_size, block_size >> > ();
//	cudaDeviceSynchronize();
//
//	cudaDeviceReset();
//	return 0;
//}