#include <iostream>
#include <cstdio>
#include <cmath>

using namespace std;

struct cache_content {
    bool v;
    unsigned int tag;
    unsigned int age;
    // unsigned int data[16];
};

const int K = 1024;

double simulate (int ways, int cache_size, int block_size) {
    unsigned int tag, index, x;

    // Show the informations
    cout << "ways: " << ways << endl;
    cout << "cache size: " << cache_size << endl;
    cout << "block size: " << block_size << endl;

    int byte_offset_bit = log2(block_size);
    int block_offset_bit = log2(ways);
    int offset_bit = byte_offset_bit + block_offset_bit;
    int index_bit = log2(cache_size / ways / block_size);
    int line = cache_size >> offset_bit;

    cache_content** cache = new cache_content*[line];
    for (int i = 0; i < line; i++) {
        cache[i] = new cache_content[ways];
        for(int j = 0; j < ways; j++) {
            cache[i][j].v = false;
            cache[i][j].tag = 0;
            cache[i][j].age = 0;
        }
    }

    FILE *fp = fopen("Trace.txt", "r");
    if (!fp) {
        cout << "File cannot open" << endl;
        exit(1);
    }

    int num_of_access = 0;
    int num_of_miss = 0;

    while (fscanf(fp, "%x", &x) != EOF) {
        num_of_access++;

        index = (x >> byte_offset_bit) & ((int)pow(2, (double)index_bit) - 1);
        tag = x >> (index_bit + byte_offset_bit);

        int hit = false;
        // go through all sets to find if hit
        for (int i = 0; i < ways; i++) {
            // update age when we have an used box which match our tag
            if (cache[index][i].v && (cache[index][i].tag == tag)) {
                cache[index][i].v = true;
                cache[index][i].age = num_of_access;
                hit = true;
                break;
            }
        }

        if (!hit) {
            num_of_miss++;

            int min = cache[index][0].age;
            int chosen = 0;
            for (int i = 0; i < ways; i++) {
                // pick an unused one
                if (!cache[index][i].v) {
                    chosen = i;
                    break;
                // LRU find an access farest from now
                } else if (cache[index][i].age < min) {
                    min = cache[index][i].age;
                    chosen = i;
                }
            }

            // replace this block
            cache[index][chosen].v = true;
            cache[index][chosen].age = num_of_access;
            cache[index][chosen].tag = tag;
        }
    }

    fclose(fp);

    for (int i = 0; i < line; i++)
        delete[] cache[i];
    delete[] cache;

    double miss_rate = num_of_miss / (double)num_of_access;
    cout << "miss rate: " << miss_rate << endl;
    cout << "===========" << endl;

    return miss_rate;

}

int main(int argc, char const *argv[]) {
    FILE* resultA = fopen("resultA.csv", "w");
    FILE* resultB = fopen("resultB.csv", "w");

    // Part a.
    // Fix the associativity on 1(direct map cache)
    // observe the difference when adapting the cache size and block size
    fprintf(resultA, "%lf,", simulate(1, 64, 4));
    fprintf(resultA, "%lf,", simulate(1, 64, 8));
    fprintf(resultA, "%lf,", simulate(1, 64, 16));
    fprintf(resultA, "%lf\n", simulate(1, 64, 32));

    fprintf(resultA, "%lf,", simulate(1, 128, 4));
    fprintf(resultA, "%lf,", simulate(1, 128, 8));
    fprintf(resultA, "%lf,", simulate(1, 128, 16));
    fprintf(resultA, "%lf\n", simulate(1, 128, 32));

    fprintf(resultA, "%lf,", simulate(1, 256, 4));
    fprintf(resultA, "%lf,", simulate(1, 256, 8));
    fprintf(resultA, "%lf,", simulate(1, 256, 16));
    fprintf(resultA, "%lf\n", simulate(1, 256, 32));

    fprintf(resultA, "%lf,", simulate(1, 512, 4));
    fprintf(resultA, "%lf,", simulate(1, 512, 8));
    fprintf(resultA, "%lf,", simulate(1, 512, 16));
    fprintf(resultA, "%lf\n", simulate(1, 512, 32));

    // Part b.
    // Fix the block size on 32(byte)
    // observe the difference when adapting the cache size and associativity
    fprintf(resultB, "%lf,", simulate(1, 1*K, 32));
    fprintf(resultB, "%lf,", simulate(2, 1*K, 32));
    fprintf(resultB, "%lf,", simulate(4, 1*K, 32));
    fprintf(resultB, "%lf\n", simulate(8, 1*K, 32));

    fprintf(resultB, "%lf,", simulate(1, 2*K, 32));
    fprintf(resultB, "%lf,", simulate(2, 2*K, 32));
    fprintf(resultB, "%lf,", simulate(4, 2*K, 32));
    fprintf(resultB, "%lf\n", simulate(8, 2*K, 32));

    fprintf(resultB, "%lf,", simulate(1, 4*K, 32));
    fprintf(resultB, "%lf,", simulate(2, 4*K, 32));
    fprintf(resultB, "%lf,", simulate(4, 4*K, 32));
    fprintf(resultB, "%lf\n", simulate(8, 4*K, 32));

    fprintf(resultB, "%lf,", simulate(1, 8*K, 32));
    fprintf(resultB, "%lf,", simulate(2, 8*K, 32));
    fprintf(resultB, "%lf,", simulate(4, 8*K, 32));
    fprintf(resultB, "%lf\n", simulate(8, 8*K, 32));

    fprintf(resultB, "%lf,", simulate(1, 16*K, 32));
    fprintf(resultB, "%lf,", simulate(2, 16*K, 32));
    fprintf(resultB, "%lf,", simulate(4, 16*K, 32));
    fprintf(resultB, "%lf\n", simulate(8, 16*K, 32));

    fprintf(resultB, "%lf,", simulate(1, 32*K, 32));
    fprintf(resultB, "%lf,", simulate(2, 32*K, 32));
    fprintf(resultB, "%lf,", simulate(4, 32*K, 32));
    fprintf(resultB, "%lf\n", simulate(8, 32*K, 32));

    fclose(resultA);
    fclose(resultB);
    
    return 0;
}
