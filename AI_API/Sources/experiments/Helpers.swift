import Foundation

func getFilePath(fileName: String) -> String? {
    // on iOS, the directory structure for app-bundled files is collapsed
    
    // strip off everything except the last part of the path
    let parts = fileName.split(separator: "/")
    let pathStrippedFN = String(parts[parts.count - 1])
    let fnParts = pathStrippedFN.split(separator: ".")
    let fnNoExt = fnParts[0 ..< fnParts.count-1].joined(separator: ".")
    let ext = String(fnParts[fnParts.count-1])
    
    let bundlePath = Bundle.main.path(forResource: fnNoExt, ofType: ext)!
    return bundlePath

//    let fileManager = FileManager.default
//    let currentDirectory = fileManager.currentDirectoryPath
//    let currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
//    
//    // Appending the file name to the current directory path
//    let fileURL = currentDirectoryURL.appendingPathComponent(fileName)
//    
//    return fileURL.path
    
}

