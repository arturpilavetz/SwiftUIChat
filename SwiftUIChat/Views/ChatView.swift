//
//  File.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI
import Combine

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel
	@State private var newMessage: String = ""
	@FocusState private var isInputFocused: Bool

	var body: some View {
		VStack(spacing: 0) {
			ScrollViewReader { proxy in
				ScrollView {
					VStack(spacing: 8) {
						ForEach(viewModel.messages) { message in
							MessageView(message: message)
								.id(message.id)
						}
					}
					.padding(.vertical, 12)
					.padding(.horizontal)
				}
				.onTapGesture {
					isInputFocused = false
				}
				.onChange(of: viewModel.messages.count) { _ in
					scrollToBottom(using: proxy)
				}
				.onChange(of: isInputFocused) { focused in
					if focused {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
							scrollToBottom(using: proxy)
						}
					}
				}
				.onAppear {
					scrollToBottom(using: proxy)
				}
			}
			.frame(maxHeight: .infinity)

			Divider()

			HStack {
				TextField("Type your message...", text: $newMessage)
					.focused($isInputFocused)
					.textFieldStyle(.roundedBorder)
					.onSubmit {
						sendMessage()
					}

				Button(action: sendMessage) {
					Image(systemName: "paperplane.fill")
						.rotationEffect(.degrees(45))
						.padding(.leading, 8)
				}
				.disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
			}
			.padding()
			.background(.thinMaterial)
		}
	}

	private func sendMessage() {
		let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }

		viewModel.addMessage(text: trimmed)
		newMessage = ""

		isInputFocused = true
	}

	private func scrollToBottom(using proxy: ScrollViewProxy) {
		if let last = viewModel.messages.last?.id {
			DispatchQueue.main.async {
				withAnimation(.easeOut(duration: 0.3)) {
					proxy.scrollTo(last, anchor: .bottom)
				}
			}
		}
	}
}

#Preview {
	ChatView(viewModel: ChatViewModel())
}
