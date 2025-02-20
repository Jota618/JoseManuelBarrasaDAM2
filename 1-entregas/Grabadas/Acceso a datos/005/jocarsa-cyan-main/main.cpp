#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <chrono>
#include <ctime>

int main(int argc, char* argv[])
{
    // Uso:
    //   1) <programa> <databaseName> select
    //   2) <programa> <databaseName> insert <jsonData>
    //   3) <programa> <databaseName> delete <fileName>
    //   4) <programa> <databaseName> update <fileName> <jsonData>
    //   5) <programa> <databaseName> export [exportFileName]
    //
    // Ejemplos:
    //   cyan.exe MyDatabase select
    //   cyan.exe MyDatabase insert "{\"name\":\"John\",\"age\":30}"
    //   cyan.exe MyDatabase delete record_1670000000.json
    //   cyan.exe MyDatabase update record_1670000000.json "{\"name\":\"Jane\",\"age\":25}"
    //   cyan.exe MyDatabase export all_records.json

    if (argc < 3) {
        std::cerr << "Uso:\n"
                  << "  " << argv[0] << " <databaseName> select\n"
                  << "  " << argv[0] << " <databaseName> insert <jsonData>\n"
                  << "  " << argv[0] << " <databaseName> delete <fileName>\n"
                  << "  " << argv[0] << " <databaseName> update <fileName> <jsonData>\n"
                  << "  " << argv[0] << " <databaseName> export [exportFileName]\n";
        return 1;
    }

    // Extraer argumentos
    std::string databaseName = argv[1];
    std::string operation    = argv[2];

    // Asegurar que la carpeta de la base de datos existe (o crearla)
    try {
        std::filesystem::create_directories(databaseName);
    } catch (const std::exception &ex) {
        std::cerr << "Error al crear/verificar el directorio: " << ex.what() << '\n';
        return 1;
    }

    if (operation == "select") {
        // Listar todos los ficheros JSON y mostrar su contenido
        try {
            for (const auto& entry : std::filesystem::directory_iterator(databaseName)) {
                if (entry.is_regular_file() && entry.path().extension() == ".json") {
                    std::ifstream ifs(entry.path());
                    if (!ifs) {
                        std::cerr << "Error al abrir el fichero: " << entry.path() << '\n';
                        continue;
                    }
                    std::string content((std::istreambuf_iterator<char>(ifs)),
                                        std::istreambuf_iterator<char>());
                    std::cout << "Fichero: " << entry.path().filename().string() << '\n';
                    std::cout << "Contenido:\n" << content << "\n\n";
                }
            }
        } catch (const std::exception &ex) {
            std::cerr << "Error leyendo el contenido del directorio: " << ex.what() << '\n';
            return 1;
        }
    }
    else if (operation == "insert") {
        // Insertar un nuevo registro a partir de jsonData
        if (argc < 4) {
            std::cerr << "Error: Falta el JSON para la operación insert.\n";
            return 1;
        }
        std::string jsonData = argv[3];

        // Crear un nombre de fichero basado en el tiempo actual
        auto now = std::chrono::system_clock::now();
        auto now_c = std::chrono::system_clock::to_time_t(now);
        std::string fileName = "record_" + std::to_string(now_c) + ".json";
        std::filesystem::path filePath = std::filesystem::path(databaseName) / fileName;

        try {
            std::ofstream ofs(filePath);
            if (!ofs) {
                std::cerr << "Error al crear el fichero: " << filePath.string() << '\n';
                return 1;
            }
            ofs << jsonData;
            ofs.close();
            std::cout << "Datos insertados correctamente en: " << filePath.string() << '\n';
        } catch (const std::exception &ex) {
            std::cerr << "Error al escribir el fichero: " << ex.what() << '\n';
            return 1;
        }
    }
    else if (operation == "delete") {
        // Eliminar un fichero especificado (se espera el nombre del fichero)
        if (argc < 4) {
            std::cerr << "Error: Falta el nombre del fichero para la operación delete.\n";
            return 1;
        }
        std::string fileName = argv[3];
        std::filesystem::path filePath = std::filesystem::path(databaseName) / fileName;
        if (!std::filesystem::exists(filePath)) {
            std::cerr << "Error: El fichero " << filePath.string() << " no existe.\n";
            return 1;
        }
        try {
            std::filesystem::remove(filePath);
            std::cout << "Fichero " << filePath.string() << " eliminado correctamente.\n";
        } catch (const std::exception &ex) {
            std::cerr << "Error al eliminar el fichero: " << ex.what() << '\n';
            return 1;
        }
    }
    else if (operation == "update") {
        // Actualizar un fichero existente con nuevos datos JSON
        if (argc < 5) {  // Asegurar que hay suficientes parámetros
            std::cerr << "Error: Se requieren <fileName> y <jsonData> para 'update'.\n";
            return 1;
        }
        
        std::string fileName = argv[3];
        std::string jsonData = argv[4];  // Índice corregido a 4
        std::filesystem::path filePath = std::filesystem::path(databaseName) / fileName;

        // Verificar que el archivo existe
        if (!std::filesystem::exists(filePath)) {
            std::cerr << "Error: Archivo no encontrado.\n";
            return 1;
        }

        // Sobrescribir el archivo
        std::ofstream file(filePath, std::ios::trunc);
        if (!file.is_open()) {
            std::cerr << "Error al abrir el archivo.\n";
            return 1;
        }
        file << jsonData;
        std::cout << "Actualizado correctamente: " << fileName << "\n";
    }
    else if (operation == "export") {
        // Exportar todos los ficheros JSON a un único fichero JSON que contiene un array de registros.
        // Se puede pasar un nombre de fichero de exportación (opcional)
        std::string exportFileName = (argc >= 4) ? argv[3] : "export.json";
        std::filesystem::path exportFilePath = std::filesystem::path(exportFileName);
        try {
            std::ofstream ofs(exportFilePath);
            if (!ofs) {
                std::cerr << "Error al crear el fichero de exportación: " << exportFilePath.string() << '\n';
                return 1;
            }
            ofs << "[\n";
            bool first = true;
            for (const auto& entry : std::filesystem::directory_iterator(databaseName)) {
                if (entry.is_regular_file() && entry.path().extension() == ".json") {
                    std::ifstream ifs(entry.path());
                    if (!ifs) {
                        std::cerr << "Error al abrir el fichero: " << entry.path() << '\n';
                        continue;
                    }
                    std::string content((std::istreambuf_iterator<char>(ifs)),
                                        std::istreambuf_iterator<char>());
                    if (!first) {
                        ofs << ",\n";
                    }
                    ofs << content;
                    first = false;
                }
            }
            ofs << "\n]";
            ofs.close();
            std::cout << "Exportación completada correctamente en: " << exportFilePath.string() << '\n';
        } catch (const std::exception &ex) {
            std::cerr << "Error durante la exportación: " << ex.what() << '\n';
            return 1;
        }
    }
    else {
        std::cerr << "Error: Operación desconocida '" << operation << "'. Usa 'select', 'insert', 'delete', 'update' o 'export'.\n";
        return 1;
    }

    return 0;
}