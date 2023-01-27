import UIKit

extension TextController {
    /// Ищет текст по запросу
    func search(_ string: String) {
        let allText = getViewer().getText() as NSString
        var searchRange = NSRange(location: 0, length: allText.length)
        var result = [NSRange]()
        while true {
            let foundRange = allText.range(of: string, range: searchRange)
            if foundRange.location != NSNotFound {
                result.append(foundRange)
                let newSearchRangeLocation = foundRange.location + foundRange.length
                searchRange = NSRange(location: newSearchRangeLocation,
                                      length: allText.length - newSearchRangeLocation)
            } else {
                break
            }
        }
        getViewer().highlightRanges(result)
    }
    
    /// заменяет заданный текст
    func replace(ranges: [NSRange], replaceString: String) {
        let allText = getViewer().getText()
        var result = allText
        for range in ranges.reversed() {
            result = (result as NSString).replacingCharacters(in: range, with: replaceString)
        }
        getViewer().updateTextView(text: result)
    }
}
