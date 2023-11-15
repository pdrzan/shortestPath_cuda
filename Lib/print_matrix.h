void print_matrix(float *matrix, int size)
{
    int n = sqrt(size);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            if(matrix[i * n + j] == __FLT_MAX__)
            {
                std::cout << std::setw(5) << "inf" << ' ';
            }
            else
            {
                std::cout << std::setw(5) << matrix[i * n + j] << ' ';
            }
        }
        std::cout << '\n';
    }
}