#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <iostream>
#include <iomanip> 
#include "../Lib/init.h"
#include "../Lib/verify.h"
#include "../Lib/cpu.h"
#include "../Lib/time_analysis.h"
#include "matrix_tiled.h"

const int N = 4;

int main(int argc, char *argv[])
{

    int device_id, number_of_sms;
    clock_t start, end;
    int n = atoi(argv[1]);
    bool print_matrix_option;

    if(argv[2] == nullptr || strcmp(argv[2], "yes") != 0)
    {
        print_matrix_option = false;
    }
    else
    {
        print_matrix_option = true;
    }

    cudaDeviceProp device_prop;
    cudaGetDeviceProperties(&device_prop, 0);
    printf("Device %D: %s \n", 0, device_prop.name);
    cudaSetDevice(0);

    size_t bytes = n * n * sizeof(float);

    std::cout << "Matrix memory occupation" << bytes << '\n';

    float *h_a, *h_cpu, *h_tiled;
    float *d_a, *d_b, *d_tiled;
    float time_cpu, time_gpu_naive, time_gpu_tiled;

    h_a = (float *)malloc(bytes);
    // h_cpu = (float *)malloc(bytes);
    h_tiled = (float *)malloc(bytes);

    init_data_random(h_a, n * n);

    // memset(h_cpu, 0, bytes);
    memset(h_tiled, 0, bytes);

    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_tiled, bytes);

    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_tiled, h_tiled, bytes, cudaMemcpyHostToDevice);

    start = clock();
    cpu_mmatrix(h_cpu, h_a, h_a, n);
    end = clock();

    time_cpu = (double)(end - start) / CLOCKS_PER_SEC;
    std::cout << "Time: " << time_cpu << '\n';

    int n_threads = 2;
    int n_blocks = n / n_threads;

    dim3 threads(n_threads, n_threads);
    dim3 blocks(n_blocks, n_blocks);

    std::cout << "Blocks: " << n_blocks << '\n';
    std::cout << "Threads/block: " << n_threads << '\n';
    std::cout << "Threads(total) " << n_threads * n_blocks << '\n';

    time_start();
    matrixMul_tiled<<<blocks, threads>>>(d_a, n);
    cudaDeviceSynchronize();
    time_end();

    cudaMemcpy(h_tiled, d_tiled, bytes, cudaMemcpyDeviceToHost);
    std::cout << "Time: " << elapsed_time << '\n';

    check_results(h_cpu, h_a, n * n);

    free(h_cpu); free(h_tiled); free(h_a);  
    cudaFree(d_tiled); cudaFree(d_a); cudaFree(d_b);

    return 0;
}