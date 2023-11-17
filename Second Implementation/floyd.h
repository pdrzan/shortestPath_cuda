__global__ void floyd(float *matrix, int k)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    float sum = matrix[row * N + k] + matrix[k * N + col];

    if (matrix[row * N + col] > sum)
    {
        matrix[row * N + col] = sum;
    }
}