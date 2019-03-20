import Foundation

public struct TextPart: Decodable {
    var title: String
    var texts: [String]
}

public class TextsParser {

    public static func processFile() -> [TextPart] {
        let fileURL = Bundle.main.url(forResource: "Texts", withExtension: ".json")

        do {
            let data = try Data(contentsOf: fileURL!, options: .mappedIfSafe)
            let json = try JSONDecoder().decode([TextPart].self, from: data)

            return json
        } catch let error {
            fatalError(error.localizedDescription)
        }

    }
}
