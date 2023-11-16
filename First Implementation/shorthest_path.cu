#define N 4

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
#include "../Lib/copy.h"
#include "../Lib/print_matrix.h"
#include "matrix_tiled.h"

int main(int argc, char *argv[])
{
    clock_t start, end;
    int n = atoi(argv[1]);
    bool print_matrix_option;

    if (argv[2] == nullptr || strcmp(argv[2], "yes") != 0)
    {
        print_matrix_option = false;
    }
    else
    {
        print_matrix_option = true;
    }

    cudaDeviceProp device_prop;
    cudaGetDeviceProperties(&device_prop, 0);
    std::cout << "Device " << 0 << ": " << device_prop.name << '\n';
    cudaSetDevice(0);

    size_t bytes = n * n * sizeof(float);

    std::cout << "Matrix memory occupation " << bytes << '\n';

    float *h_a, *h_cpu_a, *h_cpu_b, *h_tiled;
    float *d_a, *d_tiled;
    float time_cpu, time_gpu_tiled;

    h_a = (float *)malloc(bytes);
    h_tiled = (float *)malloc(bytes);
    h_cpu_a = (float *)malloc(bytes);
    h_cpu_b = (float *)malloc(bytes);

    init_data_random(h_a, n * n);

    if (print_matrix_option)
    {
        std::cout << "Initial distance matrix:\n";
        print_matrix(h_a, n * n);
    }

    memset(h_tiled, 0, bytes);
    memset(h_cpu_b, 0, bytes);

    copy_matrix(h_a, h_cpu_a, n * n);

    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_tiled, bytes);

    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_tiled, h_tiled, bytes, cudaMemcpyHostToDevice);

    bool is_matrix_a_with_data = true;
    start = clock();
    for (int i = 1; i < n * 2; i = i << 1)
    {
        if (is_matrix_a_with_data)
        {
            cpu_mmatrix(h_cpu_b, h_cpu_a, h_cpu_a, n);
            is_matrix_a_with_data = false;
        }
        else
        {
            cpu_mmatrix(h_cpu_a, h_cpu_b, h_cpu_b, n);
            is_matrix_a_with_data = true;
        }
    }
    end = clock();
    if (!is_matrix_a_with_data)
    {
        copy_matrix(h_cpu_b, h_cpu_a, n * n);
    }

    time_cpu = (double)(end - start) / CLOCKS_PER_SEC;
    std::cout << "Time cpu: " << std::fixed << time_cpu << '\n';

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

    cudaMemcpy(h_a, d_a, bytes, cudaMemcpyDeviceToHost);
    time_gpu_tiled = elapsed_time;
    std::cout << "Time gpu: " << std::fixed << time_gpu_tiled << '\n';

    if (print_matrix_option)
    {
        std::cout << "Resulting distance matrix:\n";
        print_matrix(h_a, n * n);
    }

    check_results(h_cpu_a, h_a, n * n);

    free(h_cpu_a);
    free(h_cpu_b);
    free(h_tiled);
    free(h_a);
    cudaFree(d_tiled);
    cudaFree(d_a);

    return 0;
}