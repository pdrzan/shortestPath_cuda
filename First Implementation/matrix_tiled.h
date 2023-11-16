__global__ void matrixMul_tiled(float *a, int n)
{
    // Compute each thread's global row and column index
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    // Statically allocated shared memory
    __shared__ int s_a[SHMEM_SIZE];
    __shared__ int s_b[SHMEM_SIZE];

    // Accumulate in temporary variable
    int tmp = __FLT_MAX__;

    // Sweep tile across matrix
    for (int k = 1; k < n * 2; k = k << 1)
    {
        for (int i = 0; i < n; i += blockDim.x)
        {
            // Load in elements for this tile
            s_a[threadIdx.y * blockDim.x + threadIdx.x] = a[row * n + i + threadIdx.x];
            s_b[threadIdx.y * blockDim.x + threadIdx.x] = a[i * n + threadIdx.y * n + col];

            // Wait for both tiles to be loaded in before doing computation
            __syncthreads();

            // Do matrix multiplication on the small matrix
            for (int j = 0; j < blockDim.x; j++)
            {
                tmp = std::min(s_a[threadIdx.y * blockDim.x + j] + s_b[j * blockDim.x + threadIdx.x], tmp);
            }

            // Wait for all threads to finish using current tiles before loading in new ones
            __syncthreads();
        }

        // Write back results
        a[row * n + col] = tmp;
    }
}