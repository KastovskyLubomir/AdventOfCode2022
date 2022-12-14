
import Foundation

func readLinesRemoveEmpty(str: String) -> [String] {
    return str.components(separatedBy: ["\n"]).filter { !$0.isEmpty }
}

// input: "Jack,Bob,Frank"
func stringWordArrayToArrayOfWords(input: String, separators: CharacterSet) -> [String] {
    return input.components(separatedBy: separators).filter { !$0.isEmpty }
}

// input: "1,2,3,4,5"
func stringNumArrayToArrayOfInt(input: String, separators: CharacterSet) -> [Int] {
    let strArray = input.components(separatedBy: separators)
    return strArray.compactMap { Int($0) }
}

// input: "1","2","3"
func strArrayToIntArray(strArray: [String]) -> [Int] {
    return strArray.compactMap { Int($0) }
}

func getStringBytes(str: String) -> [UInt8] {
    let buf1 = [UInt8](str.utf8)
    return buf1
}

func swap<T>(_ a: inout T,_ b: inout T) {
    (a, b) = (b, a)
}

func outputToFile(output: String) {
    let fileManager = FileManager.default
    let fileDir: String = fileManager.currentDirectoryPath
    let filePath: String = fileDir.appending("/../output.txt")
    let outputData = output.data(using: .utf8)
    fileManager.createFile(atPath: filePath, contents: outputData)
}

let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let inputString: String = String(data: data!, encoding: String.Encoding.utf8)!
