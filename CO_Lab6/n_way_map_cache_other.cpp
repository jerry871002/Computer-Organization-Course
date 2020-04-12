#include <iostream>
#include <cstdio>
#include <cmath>

using namespace std;

struct cache_content {
    unsigned int tag;
    unsigned int age;
    // unsigned int data[16];
};

const int K = 1024;

void simulate (int ways, int cache_size, int block_size) {
    unsigned int tag, index, x;

    int offset_bit = log2(block_size);
    int index_bit = log2(cache_size / ways / block_size);
    int line = cache_size >> (offset_bit);

    int no_of_access;
    int no_of_miss;

    cache_content *cache = new cache_content[line];
    cout << "ways: " << ways << endl;
    cout << "cache size: " << cache_size << endl;
    cout << "block size: " << block_size << endl;

    for (int j = 0; j < line; j++) {
        cache[j].tag = cache[j].age = 0;
    }

    FILE *fp = fopen("Trace.txt", "r");
    if (!fp) {
        cout << "File cannot open" << endl;
        return;
    }

    no_of_access = no_of_miss = 0;

    // age for LRU algorithm
    int age_now = 0;
    while (fscanf(fp, "%x", &x) != EOF) {
        no_of_access++;
        age_now++;

        // consider cache[] as a 2-dimension array
        // where cache[index*ways + i] == cache[index][i]
        index = (x >> offset_bit) & ((line/ways)-1);
        tag = x >> (index_bit+offset_bit);

        int hit = false;
        // go through all ways to find if hit
        for (int i = 0; i < ways; i++) {
            // update age when we have a non-clean box and match our tag
            if (cache[index*ways+i].age && cache[index*ways+i].tag == tag) {
                cache[index*ways+i].age = age_now;
                hit = true;
                break;
            }
        }

        if (!hit) {
            // no hit means miss QQ
            no_of_miss++;
            int min = 55556666, idx = 0;
            for (int i = 0; i < ways; i++) {
                // pick up a clean one
                if (cache[index*ways+i].age == 0) {
                    idx = i;
                    break;
                }
                // or find the 'youngest' one
                else if (cache[index*ways+i].age < min) {
                    min = cache[index*ways+i].age;
                    idx = i;
                }
            }
            // replace this block
            cache[index*ways+idx].age= age_now;
            cache[index*ways+idx].tag = tag;
        }
    }

    fclose(fp);

    delete [] cache;

    cout << "miss rate:" << (no_of_miss/(double)no_of_access) << endl;
    cout << "===========" << endl;

}

int main(int argc, char const *argv[]) {
        simulate(1,  1*K, 32);
        simulate(1,  2*K, 32);
        simulate(1,  4*K, 32);
        simulate(1,  8*K, 32);
        simulate(1, 16*K, 32);
        simulate(1, 32*K, 32);

        simulate(2,  1*K, 32);
        simulate(2,  2*K, 32);
        simulate(2,  4*K, 32);
        simulate(2,  8*K, 32);
        simulate(2, 16*K, 32);
        simulate(2, 32*K, 32);

        simulate(4,  1*K, 32);
        simulate(4,  2*K, 32);
        simulate(4,  4*K, 32);
        simulate(4,  8*K, 32);
        simulate(4, 16*K, 32);
        simulate(4, 32*K, 32);

        simulate(8,  1*K, 32);
        simulate(8,  2*K, 32);
        simulate(8,  4*K, 32);
        simulate(8,  8*K, 32);
        simulate(8, 16*K, 32);
        simulate(8, 32*K, 32);

        return 0;
}
