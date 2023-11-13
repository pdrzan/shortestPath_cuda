#define N 1024 // Matrix NxN

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "Lib/init.h"
#include "Lib/verify.h"
#include "Lib/cpu.h"
#include "matrix_tiled.h"

__global__ void ret_naive_matrixMultiply(float *A, float *B, float *C,
                                         int numARows, int numAColumns,
                                         int numBRows, int numBColumns,
                                         int numCRows, int numCColumns)
{
    //@@ Insert code to implement matrix multiplication here
    int Row = blockIdx.y * blockDim.y + threadIdx.y;
    int Col = blockIdx.x * blockDim.x + threadIdx.x;
    if (numAColumns != numBRows)
        return;
    if ((Row < numARows) && (Col < numBColumns))
    {
        float Cvalue = 0;
        for (int k = 0; k < numAColumns; ++k)
            Cvalue += A[Row * numAColumns + k] * B[k * numBColumns + Col];
        C[Row * numCColumns + Col] = Cvalue;
    }
}

int main(int argc, char *argv[])
{

    int deviceId, numberOfSMs;
    clock_t start, end;

    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, 0);
    printf("device %d: %s \n", 0, deviceProp.name);
    cudaSetDevice(0);

    size_t bytes = N * N * sizeof(float);

    printf("Ocupação tamanho da Matriz %d\n", bytes);

    float *h_a, *h_b, *h_cpu, *h_naive, *h_tiled;
    float *d_a, *d_b, *d_naive, *d_tiled;
    float time_cpu, time_gpu_naive, time_gpu_tiled;

    h_a = (float *)malloc(bytes);
    h_b = (float *)malloc(bytes);
    h_cpu = (float *)malloc(bytes);
    h_naive = (float *)malloc(bytes);
    h_tiled = (float *)malloc(bytes);

    initDataRandom(h_a, N * N);
    initDataRandom(h_b, N * N);
    return 0;
}