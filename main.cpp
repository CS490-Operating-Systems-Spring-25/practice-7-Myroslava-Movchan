#include <fstream>
#include <thread>
#include <chrono>

int main(){
    std::ofstream outputFile("test.txt");

    for (int i = 0; i < 1000; ++i)
    {
        outputFile << "line" << i << std::endl;
        outputFile << std::flush;
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
}
