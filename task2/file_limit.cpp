#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <unistd.h>
#include <sys/resource.h>
#include <filesystem>

namespace fs = std::filesystem;

int getOpenFileCount() {
    std::string path = "/proc/" + std::to_string(getpid()) + "/fd";
    int count = 0;
    for (const auto& entry : fs::directory_iterator(path)) {
        count++;
    }
    return count;
}

int main() {
    std::vector<std::ofstream> files;
    int totalFiles = 100000;
    int batchSize = 1000;
    int fileCounter = 1;
    
    std::cout << "Process ID: " << getpid() << std::endl;

    for (int i = 0; i < totalFiles / batchSize; i++) {
        for (int j = 0; j < batchSize; j++) {
            std::string fileName = "file" + std::to_string(fileCounter) + ".txt";
            files.emplace_back(fileName);

            if (!files.back().is_open()) {
                std::cerr << "Error opening " << fileName << " at " << fileCounter << " files.\n";
                return 1;  // Exit if limit is hit
            }

            files.back() << "File number " << fileCounter << "\n";
            fileCounter++;
        }

        std::cout << "Opened " << fileCounter << " files. Open FDs: " << getOpenFileCount() << std::endl;
        sleep(1);
    }

    std::cout << "Completed opening " << totalFiles << " files.\n";
    return 0;
}
//everything started lagging very bad and multipass broke again
