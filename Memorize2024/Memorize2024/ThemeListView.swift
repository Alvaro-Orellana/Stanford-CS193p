//
//  ThemeListView.swift
//  Memorize2024
//
//  Created by Codex on 16-04-26.
//

import SwiftUI

struct ThemeListView: View {
    private let themes = EmojiMemoryGame.themes
    
    var body: some View {
        NavigationStack {
            List(themes) { theme in
                NavigationLink(value: theme) {
                    ThemeRow(theme: theme)
                }
            }
            .navigationTitle("Memorize")
            .navigationDestination(for: Theme.self) { theme in
                ContentView(theme: theme)
            }
        }
    }
}

private struct ThemeRow: View {
    let theme: Theme
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.color.gradient)
                .frame(width: 14)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(theme.name)
                    .font(.headline)
                Text(themePreview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var themePreview: String {
        theme.emoji.sorted().prefix(4).joined(separator: " ")
    }
}

struct ThemeListView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeListView()
    }
}
