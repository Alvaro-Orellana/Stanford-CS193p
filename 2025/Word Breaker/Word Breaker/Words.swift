//
//  Words.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/16/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var words = Words.shared
}

@Observable
class Words {
    private var words: [Int: Set<String>] = [:]
    static let shared = Words(from: URL(string: "https://web.stanford.edu/class/cs193p/common.words")!)

    private init(from url: URL) {
        Task {
            do {
                for try await word in url.lines {
                    words[word.count, default: []].insert(word.uppercased())
                }
            } catch {
                print("Words could not load words from \(url): \(error)")
            }
            if count > 0 {
                print("Words loaded \(count) words from \(url.absoluteString)")
            }
        }
    }
    
    var count: Int {
        words.values.reduce(0) { $0 + $1.count }
    }
    
    var isEmpty: Bool {
        words.isEmpty
    }
    
    func contains(_ word: String) -> Bool {
        words[word.count]?.contains(word.uppercased()) == true
    }

    func random(length: Int) -> String? {
        if let word = words[length]?.randomElement() {
            return word
        } else {
            print("Words could not find a random word of length \(length)")
            return nil
        }
    }
}

extension UITextChecker {
    func isAWord(_ word: String) -> Bool {
        rangeOfMisspelledWord(
            in: word,
            range: NSRange(location: 0, length: word.utf16.count),
            startingAt: 0,
            wrap: false,
            language: "en_US"
        ).location == NSNotFound
    }
}
