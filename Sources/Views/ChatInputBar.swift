//
//  ChatInputBar.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 10.09.2025.
//

import SwiftUI

struct ChatInputBar: View {
	@Binding var text: String
	@FocusState var isInputFocused: Bool
	var onSend: () -> Void

	@Binding var textFieldHeight: CGFloat
	var textFieldInsets: CGFloat
	var allowsMessageInput: Bool

	init(
		text: Binding<String>,
		isInputFocused: FocusState<Bool>,
		textFieldHeight: Binding<CGFloat>,
		textFieldInsets: CGFloat = 10,
		allowsMessageInput: Bool,
		onSend: @escaping () -> Void
	) {
		self._text = text
		self._isInputFocused = isInputFocused
		self._textFieldHeight = textFieldHeight
		self.textFieldInsets = textFieldInsets
		self.allowsMessageInput = allowsMessageInput
		self.onSend = onSend
	}

	var body: some View {
		Group {
			if #available(iOS 26.0, *) {
				modernInputBar
			} else {
				legacyInputBar
			}
		}
		.padding(.bottom, textFieldInsets)
		.padding([.leading, .trailing], textFieldInsets)
	}

	// MARK: - iOS 26+ Style
	@available(iOS 26.0, *)
	private var modernInputBar: some View {
		VStack {
			Spacer()
			HStack {
				TextField("Type your message...", text: $text, axis: .vertical)
					.lineLimit(1...5)
					.focused($isInputFocused)
					.onSubmit { onSend() }
					.accessibilityLabel("Message input field")
					.accessibilityHint("Type your message and press send")
					.allowsHitTesting(allowsMessageInput)
				Button(action: onSend) {
					Image(systemName: "paperplane.fill")
						.rotationEffect(.degrees(45))
						.padding(.leading, 8)
				}
				.disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
				.accessibilityLabel("Send message")
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 12)
			.glassEffect(in: .rect(cornerRadius: 23.0))
			.background(
				GeometryReader { geometry in
					Color.clear
						.onChange(of: geometry.size.height) { newHeight in
							textFieldHeight = newHeight
						}
						.onAppear {
							textFieldHeight = geometry.size.height
						}
				}
			)
		}
	}

	// MARK: - iOS 15–18 Style
	private var legacyInputBar: some View {
		VStack {
			Spacer()
			HStack {
				ZStack(alignment: .topLeading) {
					TextEditor(text: $text)
						.frame(minHeight: 36, maxHeight: 120)
						.fixedSize(horizontal: false, vertical: true)
						.focused($isInputFocused)
						.clipped()
						.clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
						.allowsHitTesting(allowsMessageInput)
						.introspect(.textEditor, on: .iOS(.v15, .v16, .v17, .v18)) { textEditor in
							textEditor.backgroundColor = .clear
						}

					if text.isEmpty {
						Text("Type your message...")
							.foregroundColor(.gray)
							.padding(.horizontal, 4)
							.padding(.vertical, 8)
							.allowsHitTesting(false)
							.accessibilityHidden(true)
					}
				}

				Button(action: onSend) {
					Image(systemName: "paperplane.fill")
						.rotationEffect(.degrees(45))
						.padding(.leading, 8)
				}
				.disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
				.accessibilityLabel("Send message")
			}
			.padding(.horizontal, 14)
			.padding(.vertical, 6)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
			.background(
				GeometryReader { geometry in
					Color.clear
						.onChange(of: geometry.size.height) { newHeight in
							textFieldHeight = newHeight
						}
						.onAppear {
							textFieldHeight = geometry.size.height
						}
				}
			)
		}
	}
}


