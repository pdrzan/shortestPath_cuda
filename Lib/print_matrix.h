void printMatrix(float *matrix, int size)
{
    int n = sqrt(size);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            std::cout << matrix[i * n + j] << ' ';
        }
        std::cout << '\n';
    }
}