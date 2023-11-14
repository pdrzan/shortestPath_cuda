#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <iostream>
#include "../Lib/cpu.h"
#include "../Lib/init.h"

int main(int argc, char *argv[])
{
    clock_t start, end;
    float *matrixA, *matrixB;
    int n = atoi(argv[1]);

    matrixA = (float *)malloc(sizeof(float) * n * n);
    matrixB = (float *)malloc(sizeof(float) * n * n);
    for (int i = 0; i < n * n; i++)
    {
        matrixA[i] = __FLT_MAX__;
    }
    // 0 2 3 ∞ ∞ ∞ ∞ ∞ ∞
    // ∞ 0 ∞ ∞ ∞ 1 ∞ ∞ ∞
    // ∞ ∞ 0 1 2 ∞ ∞ ∞ ∞
    // ∞ ∞ ∞ 0 ∞ ∞ 2 ∞ ∞
    // ∞ ∞ ∞ ∞ 0 ∞ ∞ ∞ ∞
    // ∞ ∞ ∞ ∞ ∞ 0 2 3 2
    // ∞ ∞ ∞ ∞ 1 ∞ 0 1 ∞
    // ∞ ∞ ∞ ∞ ∞ ∞ ∞ 0 ∞
    // ∞ ∞ ∞ ∞ ∞ ∞ ∞ 1 0
    matrixA[0] = 0;
    matrixA[1] = 2;
    matrixA[2] = 3;

    matrixA[9 * 1 + 1] = 0;
    matrixA[9 * 1 + 5] = 1;

    matrixA[9 * 2 + 2] = 0;
    matrixA[9 * 2 + 3] = 1;
    matrixA[9 * 2 + 4] = 2;

    matrixA[9 * 3 + 3] = 0;
    matrixA[9 * 3 + 6] = 2;

    matrixA[9 * 4 + 4] = 0;

    matrixA[9 * 5 + 5] = 0;
    matrixA[9 * 5 + 6] = 2;
    matrixA[9 * 5 + 7] = 3;
    matrixA[9 * 5 + 8] = 2;

    matrixA[9 * 6 + 4] = 1;
    matrixA[9 * 6 + 6] = 0;
    matrixA[9 * 6 + 7] = 1;

    matrixA[9 * 7 + 7] = 0;

    matrixA[9 * 8 + 7] = 1;
    matrixA[9 * 8 + 8] = 0;
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < n; j++)
        {
            std::cout << matrixA[i*n + j] << ' ';
        }
        std::cout << '\n';
    }
    // initDataRandom(matrixA, n * n);

    bool isA = true;
    for (int i = 1; i < n * 2; i = i << 1)
    {
        if (isA)
        {
            cpu_mmatrix(matrixB, matrixA, matrixA, n);
            isA = false;
        }
        else
        {
            cpu_mmatrix(matrixA, matrixB, matrixB, n);
            isA = true;
        }
    }

    if (isA)
    {
        for(int i = 0; i < n; i++)
        {
            for(int j = 0; j < n; j++)
            {
                std::cout << matrixB[i*n + j] << ' ';
            }
            std::cout << '\n';
        }
    }
    else
    {
        for(int i = 0; i < n; i++)
        {
            for(int j = 0; j < n; j++)
            {
                std::cout << matrixA[i*n + j] << ' ';
            }
            std::cout << '\n';
        }
    }

    return 0;
}