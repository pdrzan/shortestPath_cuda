#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <iostream>
#include <typeinfo>
#include "../Lib/cpu.h"
#include "../Lib/init.h"
#include "../Lib/print_matrix.h"

int main(int argc, char *argv[])
{
    clock_t start, end;
    float *matrixA, *matrixB;
    int n = atoi(argv[1]);

    bool printMatrixOption;

    if(strcmp(argv[2], "yes") != 0)
    {
        printMatrixOption = false;
    }
    else
    {
        printMatrixOption = true;
    }

    matrixA = (float *)malloc(sizeof(float) * n * n);
    matrixB = (float *)malloc(sizeof(float) * n * n);

    initDataRandom(matrixA, n * n);
    
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

    if(printMatrixOption)
    {
        if (isA)
        {
            printMatrix(matrixB, n * n);
        }
        else
        {
            printMatrix(matrixA, n * n);
        }
    }

    return 0;
}