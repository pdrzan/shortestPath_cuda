#define N 1024 // Matrix NxN

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "../Lib/init.h"
#include "../Lib/verify.h"
#include "../Lib/cpu.h"
#include "matrix_tiled.h"

int main(int argc, char *argv[])
{

    int deviceId, numberOfSMs;
    clock_t start, end;

    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, 0);
    printf("device %d: %s \n", 0, deviceProp.name);
    cudaSetDevice(0);

    size_t bytes = N * N * sizeof(float);

    printf("Matrix memory occupation %d\n", bytes);

    float *h_a, *h_b, *h_cpu, *h_naive, *h_tiled;
    float *d_a, *d_b, *d_naive, *d_tiled;
    float time_cpu, time_gpu_naive, time_gpu_tiled;

    h_a = (float *)malloc(bytes);
    h_b = (float *)malloc(bytes);
    h_cpu = (float *)malloc(bytes);
    h_tiled = (float *)malloc(bytes);

    initDataRandom(h_a, N * N);
    initDataRandom(h_b, N * N);

    return 0;
}