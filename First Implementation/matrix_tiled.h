const int SHMEM_SIZE = N;

__global__ void matrixMul_tiled(float *a)
{
    // Compute each thread's global row and column index
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    // Statically allocated shared memory
    __shared__ float s_a[SHMEM_SIZE];
    __shared__ float s_b[SHMEM_SIZE];

    // Accumulate in temporary variable
    float tmp = __FLT_MAX__;

    // Sweep tile across matrix=
    __syncthreads();
    for (int i = 0; i < N; i += blockDim.x)
    {
        // Load in elements for this tile
        s_a[threadIdx.y * blockDim.x + threadIdx.x] = a[row * N + i + threadIdx.x];
        s_b[threadIdx.y * blockDim.x + threadIdx.x] = a[i * N + threadIdx.y * N + col];

        // Wait for both tiles to be loaded in before doing computation
        __syncthreads();

        // Do matrix multiplication on the small matrix
        for (int j = 0; j < blockDim.x; j++)
        {
            float localtmp = s_a[threadIdx.y * blockDim.x + j] + s_b[j * blockDim.x + threadIdx.x];
            if (localtmp < tmp)
            {
                tmp = localtmp;
            }
        }

        // Wait for all threads to finish using current tiles before loading in new ones
        __syncthreads();
    }
    // Write back results
    a[row * N + col] = tmp;
    __syncthreads();
}