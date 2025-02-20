#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <chrono>
#include <ctime>

int main(int argc, char* argv[])
{
    // Simple usage check
    if (argc < 3) {
        std::cerr << "Usage:\n"
                  << "  " << argv[0] << " <databaseName> select\n"
                  << "  " << argv[0] << " <databaseName> insert <jsonData>\n";
        return 1;
    }

    // Extract arguments
    std::string databaseName = argv[1];
    std::string operation    = argv[2];

    // Ensure the database folder exists
    try {
        std::filesystem::create_directories(databaseName);
    } catch (const std::exception &ex) {
        std::cerr << "Error creating/checking directory: " << ex.what() << '\n';
        return 1;
    }

    if (operation == "select") {
        try {
            for (const auto& entry : std::filesystem::directory_iterator(databaseName)) {
                if (entry.is_regular_file() && entry.path().extension() == ".json") {
                    std::ifstream ifs(entry.path());
                    if (!ifs) {
                        std::cerr << "Error opening file: " << entry.path() << '\n';
                        continue;
                    }

                    std::string content((std::istreambuf_iterator<char>(ifs)),
                                         std::istreambuf_iterator<char>());

                    std::cout << "File: " << entry.path().filename().string() << '\n';
                    std::cout << "Content:\n" << content << "\n\n";
                }
            }
        } catch (const std::exception &ex) {
            std::cerr << "Error reading directory contents: " << ex.what() << '\n';
            return 1;
        }
    }
    else if (operation == "insert") {
        if (argc < 4) {
            std::cerr << "Error: Missing JSON data for insert operation.\n";
            return 1;
        }

        std::string jsonData = argv[3];

        auto now = std::chrono::system_clock::now();
        auto now_c = std::chrono::system_clock::to_time_t(now);

        std::string fileName = "record_" + std::to_string(now_c) + ".json";
        std::filesystem::path filePath = std::filesystem::path(databaseName) / fileName;

        try {
            std::ofstream ofs(filePath);
            if (!ofs) {
                std::cerr << "Error creating file: " << filePath.string() << '\n';
                return 1;
            }
            ofs << jsonData;
            ofs.close();
            std::cout << "Data inserted successfully into: " << filePath.string() << '\n';
        } catch (const std::exception &ex) {
            std::cerr << "Error writing file: " << ex.what() << '\n';
            return 1;
        }
    }
    else {
        std::cerr << "Error: Unknown operation '" << operation << "'. Use 'select' or 'insert'.\n";
        return 1;
    }

    // Pause to keep the console window open
    std::cout << "Press Enter to continue...";
    std::cin.get();

    return 0;
}
