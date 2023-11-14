void cpu_mmatrix(float *result, float *a, float *b, int n)
{
    float temp;
    for (int i = 0; i < n; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            temp = __FLT_MAX__;
            for (int k = 0; k < n; ++k)
            {
                temp = std::min(a[i * n + k] + b[k * n + j], temp);
            }
            result[i * n + j] = temp;
        }
    }
}