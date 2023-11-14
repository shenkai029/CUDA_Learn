#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <time.h>

//__global__ void unique_gid_calculation_2d_2d(int* input)
//{
//	int tid = blockDim.x * threadIdx.y + threadIdx.x;
//
//	int num_thread_in_block = blockDim.x * blockDim.y;
//	int block_offset = num_thread_in_block * blockIdx.x;
//
//	int num_thread_in_row = num_thread_in_block * gridDim.x;
//	int row_offset = num_thread_in_row * blockIdx.y;
//
//	int gid = tid + block_offset + row_offset;
//	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx : %d, gid: %d, value : %d \n",
//		blockIdx.x, blockIdx.y, tid, gid, input[gid]);
//}

__global__ void unique_gid_calculation_3d(int* input)
{
	int tid = blockDim.x * blockDim.y * threadIdx.z + blockDim.x * threadIdx.y + threadIdx.x;

	int num_thread_in_block = blockDim.x * blockDim.y * blockDim.z;
	int block_offset = num_thread_in_block * blockIdx.x;

	int num_thread_in_row = num_thread_in_block * gridDim.x;
	int row_offset = num_thread_in_row * blockIdx.y;

	int num_thread_in_plane = num_thread_in_row * gridDim.y;
	int plane_offset = num_thread_in_plane * blockIdx.z;

	int gid = tid + block_offset + row_offset + plane_offset;
	printf("blockIdx.x : %d, blockIdx.y : %d, blockIdx.z : %d,threadIdx : %d, gid: %d, value : %d \n",
		blockIdx.x, blockIdx.y, blockIdx.z, tid, gid, input[gid]);
}


//int main()
//{
//	const int array_size = 64;
//	int array_byte_size = sizeof(int) * array_size;
//	int h_data[array_size];
//
//	time_t t;
//	srand((unsigned)time(&t));
//	for (int i = 0; i < array_size; i++)
//	{
//		h_data[i] = (int)(rand() & 0xff);
//	}
//	
//
//	for (int i = 0; i < array_size; i++)
//	{
//		printf("%d ", h_data[i]);
//		if (i % 16 == 15)
//			printf("\n");
//	}
//	printf("\n \n");
//
//	int* d_data;
//	cudaMalloc((void**)&d_data, array_byte_size);
//	cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);
//
//	dim3 block(2, 2, 2);
//	dim3 grid(2, 2, 2);
//
//	unique_gid_calculation_3d << <grid, block >> > (d_data);
//	cudaDeviceSynchronize();
//
//	cudaDeviceReset();
//	return 0;
//}