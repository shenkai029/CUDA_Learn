#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <time.h>

#include "common.h"
#include "cuda_common.cuh"

__global__ void sum_array_gpu_3(int* a, int* b, int* c, int* res, size_t size)
{
	int gid = blockIdx.x * blockDim.x + threadIdx.x;

	if (gid < size)
	{
		res[gid] = a[gid] + b[gid] + c[gid];
	}

}

void sum_array_cpu(int* a, int* b, int* c, int* res, size_t size)
{
	for (int i = 0; i < size; i++)
	{
		res[i] = a[i] + b[i] + c[i];
	}
}

//int main()
//{
//	int size = 10000000;
//	int block_size = 256;
//
//	int num_bytes = sizeof(int) * size;
//
//	// host pointers
//	int* h_a, * h_b, * h_c, * gpu_result, * cpu_result;
//
//	// allocate memory for host pointers
//	h_a = (int*)malloc(num_bytes);
//	h_b = (int*)malloc(num_bytes);
//	h_c = (int*)malloc(num_bytes);
//	gpu_result = (int*)malloc(num_bytes);
//	cpu_result = (int*)malloc(num_bytes);
//
//	// init host pointers
//	time_t t;
//	srand((unsigned)time(&t));
//	for (int i = 0; i < size; i++)
//	{
//		h_a[i] = (int)(rand() & 0x3fffff);
//	}
//
//	for (int i = 0; i < size; i++)
//	{
//		h_b[i] = (int)(rand() & 0x3fffff);
//	}
//
//	for (int i = 0; i < size; i++)
//	{
//		h_c[i] = (int)(rand() & 0x3fffff);
//	}
//
//	memset(gpu_result, 0, num_bytes);
//	memset(cpu_result, 0, num_bytes);
//
//	//summation in CPU
//	clock_t cpu_start, cpu_end;
//	cpu_start = clock();
//	sum_array_cpu(h_a, h_b, h_c, cpu_result, size);
//	cpu_end = clock();
//
//	// device pointers
//	int* d_a, * d_b, * d_c, * d_res;
//	gpuErrChk(cudaMalloc((void**)&d_a, num_bytes));
//	gpuErrChk(cudaMalloc((void**)&d_b, num_bytes));
//	gpuErrChk(cudaMalloc((void**)&d_c, num_bytes));
//	gpuErrChk(cudaMalloc((void**)&d_res, num_bytes));
//
//	//launching the grid
//	dim3 block(block_size);
//	dim3 grid((size / block.x) + 1);
//
//	clock_t htod_start, htod_end;
//	htod_start = clock();
//	cudaMemcpy(d_a, h_a, num_bytes, cudaMemcpyHostToDevice);
//	cudaMemcpy(d_b, h_b, num_bytes, cudaMemcpyHostToDevice);
//	cudaMemcpy(d_c, h_c, num_bytes, cudaMemcpyHostToDevice);
//	htod_end = clock();
//
//	clock_t gpu_start, gpu_end;
//	gpu_start = clock();
//	sum_array_gpu_3 << <grid, block >> > (d_a, d_b, d_c, d_res,size);
//	cudaDeviceSynchronize();
//	gpu_end = clock();
//
//	// memory transfer back to host
//	clock_t dtoh_start, dtoh_end;
//	dtoh_start = clock();
//	cudaMemcpy(gpu_result, d_res, num_bytes, cudaMemcpyDeviceToHost);
//	dtoh_end = clock();
//
//	// array comparison
//	compare_arrays(gpu_result, cpu_result, size);
//
//	printf("Sum array CPU execution time: %2.8f \n",
//		(double)((double)(cpu_end - cpu_start) / CLOCKS_PER_SEC));
//
//	printf("Sum array GPU execution time: %2.8f \n",
//		(double)((double)(gpu_end - gpu_start) / CLOCKS_PER_SEC));
//
//	printf("htod mem transfer time: %2.8f \n",
//		(double)((double)(htod_end - htod_start) / CLOCKS_PER_SEC));
//
//	printf("dtoh mem transfer time: %2.8f \n",
//		(double)((double)(dtoh_end - dtoh_start) / CLOCKS_PER_SEC));
//
//	printf("Sum array GPU total execution time: %2.8f \n",
//		(double)((double)(dtoh_end - htod_start) / CLOCKS_PER_SEC));
//
//	cudaFree(d_res);
//	cudaFree(d_c);
//	cudaFree(d_b);
//	cudaFree(d_a);
//
//	free(cpu_result);
//	free(gpu_result);
//	free(h_c);
//	free(h_b);
//	free(h_a);
//
//	cudaDeviceReset();
//	return 0;
//}