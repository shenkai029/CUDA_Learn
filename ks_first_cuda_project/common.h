#pragma once

#include <stdio.h>
#include <cstring>
#include <time.h>
#include <stdlib.h>
#include <sys/utime.h>
#include <fstream> 

#define HANDLE_NULL( a ){if (a == NULL) { \
                            printf( "Host memory failed in %s at line %d\n", \
                                    __FILE__, __LINE__ ); \
                            exit( EXIT_FAILURE );}}

enum INIT_PARAM {
	INIT_ZERO, INIT_RANDOM, INIT_ONE, INIT_ONE_TO_TEN, INIT_FOR_SPARSE_METRICS, INIT_0_TO_X
};

//simple initialization
void initialize(int* input, const int array_size,
	INIT_PARAM PARAM = INIT_ONE_TO_TEN, int x = 0);

void initialize(float* input, const int array_size,
	INIT_PARAM PARAM = INIT_ONE_TO_TEN);

//reduction in cpu
int reduction_cpu(int* input, const int size);

//compare results
void compare_results(int gpu_result, int cpu_result);

// compare arrays
template<typename T>
void compare_arrays(T* a, T* b, size_t size)
{
	for (int i = 0; i < size; ++i)
	{
		if (a[i] != b[i])
		{
			printf("Arrays are not equal \n");
		}
	}
	printf("Arrays are equal \n");
}

template<typename T>
void sum_array_cpu(T* a, T* b, T* c, size_t size)
{
	for (int i = 0; i < size; i++)
	{
		c[i] = a[i] + b[i];
	}
}

//print_time_using_host_clock
void print_time_using_host_clock(clock_t start, clock_t end);

//matrix transpose in CPU
void mat_transpose_cpu(int* mat, int* transpose, int nx, int ny);