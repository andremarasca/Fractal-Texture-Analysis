#include <stdlib.h>
#include "mex.h"
#include "math.h"

#define inf 2000000000
#define ABS(x) ((x) < 0 ? (-(x)) : (x))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define ERROR_MALLOC(x) if (x == NULL) printf("Fuja para as colinas!\n");

double **double2Dmalloc(int M, int N, int valor);
void double2Dfree(double **A, int M);
int ***int3Dmalloc(int M, int N, int L, int valor);
void int3Dfree(int ***A, int M, int N);
void DT (double *X, double *Y, double *Z, double *Lab, int Nvox, int M, int N, int L);
void inicializa(double *X, double *Y, double *Z, double *Lab, int Nvox, int ***A, int ***V);
void step1 (int ***A, int ***V, int M, int N, int L);
void step2 (int ***A, int ***V, int M, int N, int L);
void step3 (int ***A, int ***V, int M, int N, int L);
void contagem (int ***A, int ***V, int M, int N, int L);

int BIT[31] = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824};
int *quadrado;
double **contador;
int RMAX, RQuadMax, N_labels;

void mexFunction(
    int nlhs,              // Number of left hand side (output) arguments
    mxArray *plhs[],       // Array of left hand side arguments
    int nrhs,              // Number of right hand side (input) arguments
    const mxArray *prhs[]  // Array of right hand side arguments
)
{
    double *X, *Y, *Z, *Lab, *dim_in, *Vretorno;

    int Nvox, M, N, C;
    int i, j, u, nq;

    //Obter coordenadas
    X = mxGetPr(prhs[0]);
    Y = mxGetPr(prhs[1]);
    Z = mxGetPr(prhs[2]);
    Lab = mxGetPr(prhs[3]);
    // Obter o numero de voxels
    Nvox = (int) mxGetM(prhs[0]);
    //Obter dimensoes do cubo
    dim_in = mxGetPr(prhs[4]);
    M = (int)dim_in[0];
    N = (int)dim_in[1];
    C = (int)dim_in[2];
    //obter informacoes de EDT
    RMAX = (int) mxGetScalar(prhs[5]);
    N_labels = (int) mxGetScalar(prhs[6]);

    nq = 46000;

    quadrado = (int *) malloc(nq * sizeof(int));
    ERROR_MALLOC(quadrado);

    for (i = 0; i < nq; i++)
        quadrado[i] = i * i;

    RQuadMax = RMAX * RMAX + 1;
    contador = double2Dmalloc(N_labels, RQuadMax, 0);

    DT(X, Y, Z, Lab, Nvox, M, N, C);

    //Retornar Contagem
    const mwSize outDims[2] = {(const mwSize)N_labels, (const mwSize) RQuadMax};
    plhs[0] = (mxArray *) mxCreateNumericArray(2, outDims, mxDOUBLE_CLASS, mxREAL);
    Vretorno = mxGetPr(plhs[0]);

    u = 0;
    for(j = 0; j < RQuadMax; j++)
        for (i = 0; i < N_labels; i++)
            Vretorno[u++] = (double) contador[i][j];

    double2Dfree(contador, N_labels);
    free(quadrado);
}

double **double2Dmalloc(int M, int N, int valor)
{
    int i, j;
    double **A = (double **) malloc (M * sizeof(double*));
    ERROR_MALLOC(A);

    for(i = 0; i < M; i++)
    {
        A[i] = (double *) malloc (N * sizeof(double));
        ERROR_MALLOC(A[i]);

        for(j = 0; j < N; j++)
        {
            A[i][j] = valor;
        }
    }
    return A;
}

void double2Dfree(double **A, int M)
{
    int i;
    for(i = 0; i < M; i++)
    {
        free(A[i]);
    }
    free(A);
}

int ***int3Dmalloc(int M, int N, int L, int valor)
{
    int i, j, k;
    int ***A = (int ***)malloc(M * sizeof(int **));
    ERROR_MALLOC(A);
    for(i = 0; i < M; i++)
    {
        A[i] = (int **) malloc (N * sizeof(int*));
        ERROR_MALLOC(A[i]);
        for(j = 0; j < N; j++)
        {
            A[i][j] = (int *) malloc (L * sizeof(int));
            ERROR_MALLOC(A[i][j]);
            for(k = 0; k < L; k++)
            {
                A[i][j][k] = valor;
            }
        }
    }
    return A;
}

void int3Dfree(int ***A, int M, int N)
{
    int i, j;
    for(i = 0; i < M; i++)
    {
        for(j =0 ; j < N; j++)
        {
            free(A[i][j]);
        }
        free(A[i]);
    }
    free(A);
}

void DT (double *X, double *Y, double *Z, double *Lab, int Nvox, int M, int N, int L)
{
    M += 2 * RMAX;
    N += 2 * RMAX;
    L += 2 * RMAX;
    int ***A = int3Dmalloc(M, N, L, inf);
    int ***V = int3Dmalloc(M, N, L, 0);

    inicializa(X, Y, Z, Lab, Nvox, A, V);

    step1(A, V, M, N, L);
    step2(A, V, M, N, L);
    step3(A, V, M, N, L);

    contagem(A, V, M, N, L);

    int3Dfree(A, M, N);
    int3Dfree(V, M, N);
}

void inicializa(double *X, double *Y, double *Z, double *Lab, int Nvox, int ***A, int ***V)
{
    int u;

    for (u = 0; u < Nvox; u++)
    {
        A[(int)X[u] + RMAX][(int)Y[u] + RMAX][(int)Z[u] + RMAX] = 0;
        V[(int)X[u] + RMAX][(int)Y[u] + RMAX][(int)Z[u] + RMAX] |= (int)Lab[u];
    }
}

void step1 (int ***A, int ***V, int M, int N, int L)
{
    int i, k, j;
    int x, d, label;
    for(i = 0; i < M; i++)
    {
        for(j = 0; j < N; j++)
        {
            //FORWARD
            x = -1;
            label = V[i][j][0];
            for(k = 0 ; k < L; k++)
            {
                if (A[i][j][k] == 0)
                {
                    x = k;
                    label = V[i][j][k];
                }
                else if(x > 0)
                {
                    V[i][j][k] = label;
                    A[i][j][k] = quadrado[ABS(k - x)];
                }
            }
            //BACKWARD
            x = -1;
            label = V[i][j][L - 1];
            for(k = L - 1; k >= 0; k--)
            {
                if (A[i][j][k] == 0)
                {
                    x = k;
                    label = V[i][j][k];
                }
                else if(x > 0)
                {
                    d = quadrado[ABS(k - x)];
                    if (d < A[i][j][k])
                    {
                        V[i][j][k] = label;
                        A[i][j][k] = d;
                    }
                    else if (d == A[i][j][k])
                        V[i][j][k] |= label;
                }
            }
        }
    }
}

//Algoritmo 4
void step2 (int ***A, int ***V, int M, int N, int L)
{
    int j, k, i, a, b, m, n;
    int *buff = (int *) malloc(N * sizeof(int));
    ERROR_MALLOC(buff);
    int *buffV = (int *) malloc(N * sizeof(int));
    ERROR_MALLOC(buffV);
    for (i = 0; i < M; i++)
    {
        for (k = 0; k < L; k++)
        {
            for (j = 0; j < N; j++)
            {
                buff[j] = A[i][j][k];
                buffV[j] = V[i][j][k];
            }
            //FORWARD
            a = 0;
            for (j = 1; j < N; j++)
            {
                if (a > 0) a--;
                if (buff[j] > buff[j - 1])
                {
                    b = (buff[j] - buff[j - 1]) / 2;
                    if (b >= N - j) b = (N - 1)- j;
                    for (n = a; n <= b; n++)
                    {
                        m = buff[j - 1] + quadrado[ABS(n + 1)];
                        if (buff[j + n] < m) break;
                        if (A[i][j + n][k] > m)
                        {
                            A[i][j + n][k] = m;
                            V[i][j + n][k] = buffV[j - 1];
                        }
                        else if (m == A[i][j + n][k])
                            V[i][j + n][k] |= buffV[j - 1];
                    }
                    a = b;
                }
                else
                {
                    a = 0;
                }
            }

            //BACKWARD
            a = 0;
            for (j = N - 2; j >= 0; j--)
            {
                if (a > 0) a--;
                if (buff[j] > buff[j + 1])
                {
                    b = (buff[j] - buff[j + 1]) / 2;
                    if (j - b < 0) b = j;
                    for (n = a; n <= b; n++)
                    {
                        m = buff[j + 1] + quadrado[ABS(n + 1)];
                        if (buff[j - n] < m) break;
                        if (A[i][j - n][k] > m)
                        {
                            A[i][j - n][k] = m;
                            V[i][j - n][k] = buffV[j + 1];
                        }
                        else if (m == A[i][j - n][k])
                            V[i][j - n][k] |= buffV[j + 1];
                    }
                    a = b;
                }
                else
                {
                    a = 0;
                }
            }
        }
    }
    free(buff);
    free(buffV);
}

//Algoritmo 4
void step3 (int ***A, int ***V, int M, int N, int L)
{
    int j, k, i, a, b, m, n;
    int *buff = (int *) malloc(M * sizeof(int));
    ERROR_MALLOC(buff);
    int *buffV = (int *) malloc(M * sizeof(int));
    ERROR_MALLOC(buffV);
    for (k = 0; k < L; k++)
    {
        for (j = 0; j < N; j++)
        {
            for (i = 0; i < M; i++)
            {
                buff[i] = A[i][j][k];
                buffV[i] = V[i][j][k];
            }
            //FORWARD
            a = 0;
            for (i = 1; i < M; i++)
            {
                if (a > 0) a--;
                if (buff[i] > buff[i - 1])
                {
                    b = (buff[i] - buff[i - 1]) / 2;
                    if (b >= M - i) b = (M - 1)- i;
                    for (n = a; n <= b; n++)
                    {
                        m = buff[i - 1] + quadrado[ABS(n + 1)];
                        if (buff[i + n] < m) break;
                        if (A[i + n][j][k] > m)
                        {
                            A[i + n][j][k] = m;
                            V[i + n][j][k] = buffV[i - 1];
                        }
                        else if (m == A[i + n][j][k])
                            V[i + n][j][k] |= buffV[i - 1];
                    }
                    a = b;
                }
                else
                {
                    a = 0;
                }
            }

            //BACKWARD
            a = 0;
            for (i = M - 2; i >= 0; i--)
            {
                if (a > 0) a--;
                if (buff[i] > buff[i + 1])
                {
                    b = (buff[i] - buff[i + 1]) / 2;
                    if (i - b < 0) b = i;
                    for (n = a; n <= b; n++)
                    {
                        m = buff[i + 1] + quadrado[ABS(n + 1)];
                        if (buff[i - n] < m) break;
                        if (A[i - n][j][k] > m)
                        {
                            A[i - n][j][k] = m;
                            V[i - n][j][k] = buffV[i + 1];
                        }
                        else if (m == A[i - n][j][k])
                            V[i - n][j][k] |= buffV[i + 1];
                    }
                    a = b;
                }
                else
                {
                    a = 0;
                }
            }
        }
    }
    free(buff);
    free(buffV);
}

void contagem (int ***A, int ***V, int M, int N, int L)
{
    int i, j, k, u;

    /// contagem (histograma)
    for(k = 0; k < L; k++)
    {
        for(i = 0; i < M; i++)
        {
            for(j =0 ; j < N; j++)
            {
                if(A[i][j][k] < RQuadMax)
                {
                    for (u = 0; u < N_labels; u++)
                        if (V[i][j][k] & BIT[u])
                            contador[u][A[i][j][k]]++;
                }
            }
        }
    }

    /// "integrar" calcular o volume baseado no histograma

    for (i = 0; i < N_labels; i++)
    {
        for(j = 1; j < RQuadMax; j++)
        {
            contador[i][j] += contador[i][j - 1];
        }
    }
}
