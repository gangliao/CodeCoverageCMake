#include <stdio.h>

int baseline(int a) {
    if (a >= 3) {
        return 4;
    }
    else if (a < 0) {
        return 1;
    }
    return 0;
}