#include "sample.hpp"

#include <cstdlib>
#include <string>

int add(int a, int b) {
    return a + b;
}

int main(int argc, char** argv) {
    int x = (argc > 1) ? std::atoi(argv[1]) : 0;
    int y = (argc > 2) ? std::atoi(argv[2]) : 0;
    return add(x, y);
}
