void initDataRandom(float *matrix, int size)
{
    int n = sqrt(size);
    srand(time(NULL));
    for (int i = 0; i < n; ++i)
    {
        for(int j = 0; j < n; j++)
        {
            if(i == j)
            {
                matrix[i*n + j] = 0;
            }
            else
            {
                matrix[i*n + j] = __FLT_MAX__;
            }
        }
    }
    for (int i = 0; i < (size/4); ++i)
    {
        int ii = rand() % n;
        int jj = rand() % n;
        if (matrix[ii * n + jj] == __FLT_MAX__)
        {
            matrix[ii * n + jj] = rand() % n;
        }
    }
}