//
//  CodeView.swift
//  Word Breaker
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    let code: Code
    @Binding var selection: Int
    @ViewBuilder let ancillaryView: () -> AncillaryView

    init(
        code: Code,
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }

    var body: some View {
        HStack {
            let characters = Array(code.word)
            ForEach(characters.indices, id: \.self) { index in
                Letter.shape
                    .fill(pegColor(at: index))
                    .aspectRatio(Letter.aspectRatio, contentMode: .fit)
                    .overlay {
                        Text(characters[index].description)
                            .font(.largeTitle)
                            .foregroundStyle(Color(.systemBackground))
                    }
                    .padding(Letter.selectionPadding)
                    .background {
                        if code.kind == .guess && selection == index {
                            Letter.shape.foregroundStyle(Letter.selectionColor)
                        }
                    }
                    .onTapGesture {
                        selection = index
                    }
            }
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }
    }

    private func pegColor(at index: Int) -> Color {
        switch code.kind {
        case .master, .guess: .primary
        case .attempt(let matches):
            switch matches[index] {
            case .exact: .green
            case .inexact: .yellow
            case .noMatch: .primary
            }
        }
    }
}

private struct Letter {
    static let shape = RoundedRectangle(cornerRadius: 10)
    static let aspectRatio: CGFloat = 2/3
    static let selectionPadding: CGFloat = 9
    static let selectionColor = Color(hue: 148/360, saturation: 0, brightness: 0.8)
}
