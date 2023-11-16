#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <iostream>
#include <iomanip> 
#include <typeinfo>
#include "../Lib/cpu.h"
#include "../Lib/init.h"
#include "../Lib/print_matrix.h"

int main(int argc, char *argv[])
{
    clock_t start, end;
    float *matrix_a, *matrix_b;
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

    matrix_a = (float *)malloc(sizeof(float) * n * n);
    matrix_b = (float *)malloc(sizeof(float) * n * n);

    init_data_random(matrix_a, n * n);

    if(print_matrix_option)
    {
        std::cout << "Initial distance matrix:\n";
        print_matrix(matrix_a, n * n);
    }
    
    bool is_matrix_a_with_data = true;
    start = clock();
    for (int i = 1; i < n * 2; i = i << 1)
    {
        if (is_matrix_a_with_data)
        {
            cpu_mmatrix(matrix_b, matrix_a, matrix_a, n);
            is_matrix_a_with_data = false;
        }
        else
        {
            cpu_mmatrix(matrix_a, matrix_b, matrix_b, n);
            is_matrix_a_with_data = true;
        }
    }
    end = clock();


    if(print_matrix_option)
    {
        std::cout << "Resulting distance matrix:\n";
        if (is_matrix_a_with_data)
        {
            print_matrix(matrix_b, n * n);
        }
        else
        {
            print_matrix(matrix_a, n * n);
        }
    }

    double running_time = (double)(end - start) / CLOCKS_PER_SEC;
    std::cout << "Time: " << running_time << '\n';

    return 0;
}