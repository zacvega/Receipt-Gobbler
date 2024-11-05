import Foundation

func getFilePath(fileName: String) -> String? {
    let fileManager = FileManager.default
    let currentDirectory = fileManager.currentDirectoryPath
    let currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
    
    // Appending the file name to the current directory path
    let fileURL = currentDirectoryURL.appendingPathComponent(fileName)
    
    return fileURL.path
}

