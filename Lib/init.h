void initDataRandom(float *a, int size)
{
    int n = sqrt(size);
    srand(time(NULL));
    for (int i = 0; i < size; ++i)
    {
        a[i] = __FLT_MAX__;
    }
    for (int i = 0; i < (size/4); ++i)
    {
        int ii = rand() % n;
        int jj = rand() % n;
        if (a[ii * n + jj] == __FLT_MAX__)
        {
            a[ii * n + jj] = rand() % n;
        }
    }
}