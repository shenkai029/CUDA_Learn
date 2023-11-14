#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void unique_idx_calc_threadIdx(int* input)
{
	int tid = threadIdx.x;
	printf("threadIdx : %d, value : %d \n", tid, input[tid]);
}

__global__ void unique_gid_calculation(int* input)
{
	int tid = threadIdx.x;
	int offset = blockIdx.x * blockDim.x;
	int gid = tid + offset;
	printf("blockIdx.x : %d, threadIdx : %d, gid: %d, value : %d \n", 
		blockIdx.x, tid, gid, input[gid]);
}

__global__ void unique_gid_calculation_2d(int* input)
{
	int tid = threadIdx.x;
	int block_offset = blockIdx.x * blockDim.x;
	int row_offset = blockDim.x * gridDim.x * blockIdx.y;
	int gid = tid + block_offset + row_offset;
	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx : %d, gid: %d, value : %d \n",
		blockIdx.x, blockIdx.y, tid, gid, input[gid]);
}

__global__ void unique_gid_calculation_2d_2d(int* input)
{
	int tid = blockDim.x * threadIdx.y + threadIdx.x;

	int num_thread_in_block = blockDim.x * blockDim.y;
	int block_offset = num_thread_in_block * blockIdx.x;

	int num_thread_in_row = num_thread_in_block * gridDim.x;
	int row_offset = num_thread_in_row * blockIdx.y;

	int gid = tid + block_offset + row_offset;
	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx : %d, gid: %d, value : %d \n",
		blockIdx.x, blockIdx.y, tid, gid, input[gid]);
}


//int main()
//{
//	int array_size = 16;
//	int array_byte_size = sizeof(int) * array_size;
//	int h_data[] = { 23, 9, 4, 53, 65, 12, 1, 33, 87, 45, 23, 13, 342, 56, 44, 99 };
//
//	for (int i = 0; i < array_size; i++)
//	{
//		printf("%d ", h_data[i]);
//	}
//	printf("\n \n");
//
//	int* d_data;
//	cudaMalloc((void**)&d_data, array_byte_size);
//	cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);
//
//	dim3 block(2, 2);
//	dim3 grid(2, 2);
//
//	unique_gid_calculation_2d_2d << <grid, block >> > (d_data);
//	cudaDeviceSynchronize();
//
//	cudaDeviceReset();
//	return 0;
//}