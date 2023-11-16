void copy_matrix(float *matrix_origin, float *matrix_destiny, int size)
{
    for(int i = 0; i < size; i++)
    {
        matrix_destiny[i] = matrix_origin[i];
    }
}