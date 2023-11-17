#define N 512

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
#include "floyd.h"

int main(int argc, char *argv[])
{
    // clock_t start, end;
    bool print_matrix_option;

    if (argv[1] == nullptr || strcmp(argv[1], "yes") != 0)
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

    size_t bytes = N * N * sizeof(float);

    std::cout << "Matrix memory occupation " << bytes << '\n';

    float *h_a;//, *h_cpu_a, *h_cpu_b;
    float *d_a;
    float time_gpu_tiled;//, time_cpu;

    h_a = (float *)malloc(bytes);
    // h_cpu_a = (float *)malloc(bytes);
    // h_cpu_b = (float *)malloc(bytes);

    init_data_random(h_a, N * N);

    if (print_matrix_option)
    {
        std::cout << "Initial distance matrix:\n";
        print_matrix(h_a, N * N);
    }

    // memset(h_cpu_b, 0, bytes);

    // copy_matrix(h_a, h_cpu_a, N * N);

    cudaMalloc(&d_a, bytes);

    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);

    // bool is_matrix_a_with_data = true;
    // start = clock();
    // for (int i = 1; i < N * 2; i = i << 1)
    // {
    //     if (is_matrix_a_with_data)
    //     {
    //         cpu_mmatrix(h_cpu_b, h_cpu_a, h_cpu_a, N);
    //         is_matrix_a_with_data = false;
    //     }
    //     else
    //     {
    //         cpu_mmatrix(h_cpu_a, h_cpu_b, h_cpu_b, N);
    //         is_matrix_a_with_data = true;
    //     }
    // }
    // end = clock();
    // if (!is_matrix_a_with_data)
    // {
    //     copy_matrix(h_cpu_b, h_cpu_a, N * N);
    // }

    // time_cpu = (double)(end - start) / CLOCKS_PER_SEC;

    int n_threads = 32;
    int n_blocks = N / n_threads;

    dim3 threads(n_threads, n_threads);
    dim3 blocks(n_blocks, n_blocks);

    std::cout << "Blocks: " << n_blocks << '\n';
    std::cout << "Threads/block: " << n_threads << '\n';
    std::cout << "Threads(total) " << n_threads * n_blocks << '\n';

    time_start();
    for (int k = 0; k < N; k++)
    {
        floyd<<<blocks,threads>>>(d_a, k);
        cudaDeviceSynchronize();
    }
    time_end();

    cudaMemcpy(h_a, d_a, bytes, cudaMemcpyDeviceToHost);
    time_gpu_tiled = elapsed_time;

    if (print_matrix_option)
    {
        // std::cout << "====================================\n";
        // print_matrix(h_cpu_a, N * N);
        // std::cout << "====================================\n";
        std::cout << "Resulting distance matrix:\n";
        print_matrix(h_a, N * N);
    }

    // check_results(h_cpu_a, h_a, N * N);

    // std::cout << "Time cpu: " << std::fixed << time_cpu << '\n';
    std::cout << "Time gpu: " << std::fixed << time_gpu_tiled << " ms" << '\n';

    // free(h_cpu_a);
    // free(h_cpu_b);
    free(h_a);
    cudaFree(d_a);

    return 0;
}