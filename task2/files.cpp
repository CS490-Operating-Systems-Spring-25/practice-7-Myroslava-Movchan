#include <iostream>
#include <fstream>
#include <vector>
#include <string>

int main() {
    std::vector<std::ofstream> files;
    int fileCounter = 1;

    while (true) {  // infinite loop
        std::string fileName = "file" + std::to_string(fileCounter) + ".txt";
        files.emplace_back(fileName);

        if (!files.back().is_open()) {
            std::cerr << "Error opening " << fileName << std::endl;
        } else {
            files.back() << "This is file number " << fileCounter << std::endl;
        }

        fileCounter++;

    }

    return 0;
}
//it broke multipass, better add sleep mode for some time to make the creation process a little bit slower
