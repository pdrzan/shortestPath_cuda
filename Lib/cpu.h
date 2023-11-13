void cpu_mmatrix(float *hres, float *a, float *b, int n)
{
    float temp;
    for (int i = 0; i < n; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            temp = 0.0;
            for (int k = 0; k < n; ++k)
            {
                temp += a[i * n + k] * b[k * n + j];
            }
            hres[i * n + j] = temp;
        }
    }
}