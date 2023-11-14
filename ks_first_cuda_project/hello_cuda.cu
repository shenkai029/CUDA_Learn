#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void hello_cuda()
{
	printf("Hello CUDA World \n");
}

//int main()
//{
//	dim3 block(4, 2);
//	dim3 grid(5, 2);
//
//	hello_cuda<<<grid, block>>>();
//	cudaDeviceSynchronize();
//	
//	cudaDeviceReset();
//	return 0;
//}