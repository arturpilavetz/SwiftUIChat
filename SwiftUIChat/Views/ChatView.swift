//
//  File.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI
import Combine

struct MessageBoundsKey: PreferenceKey {
	static var defaultValue: [UUID: CGRect] = [:]
	static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
		value.merge(nextValue(), uniquingKeysWith: { $1 })
	}
}

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel
	@State private var newMessage: String = ""
	@FocusState private var isInputFocused: Bool

	@State private var messageFrames: [UUID: CGRect] = [:]
	@State private var lastVisibleMessage: UUID?

	var body: some View {
		VStack(spacing: 0) {
			ScrollViewReader { proxy in
				ScrollView {
					LazyVStack(spacing: 8) {
						ForEach(viewModel.messages) { message in
							MessageView(message: message)
								.id(message.id)
								.background(
									GeometryReader { geo in
										Color.clear.preference(
											key: MessageBoundsKey.self,
											value: [message.id: geo.frame(in: .global)]
										)
									}
								)
						}
					}
					.padding(.vertical, 12)
					.padding(.horizontal)
				}
				.defaultScrollAnchor(.bottom) // iOS 17+
				.onTapGesture { isInputFocused = false }

				.onChange(of: viewModel.messages.count) { oldValue, newValue in
					if newValue > oldValue {
						scrollToBottom(using: proxy)
					}
				}

				.onPreferenceChange(MessageBoundsKey.self) { frames in
					messageFrames = frames
					lastVisibleMessage = frames
						.min(by: { abs($0.value.maxY - UIScreen.main.bounds.height) <
								   abs($1.value.maxY - UIScreen.main.bounds.height) })?.key
				}
				.onReceive(Publishers.keyboardHeight) { height in
					guard let lastVisibleMessage else { return }
					DispatchQueue.main.async {
						withAnimation(.easeOut(duration: 0.25)) {
							proxy.scrollTo(lastVisibleMessage, anchor: .bottom)
						}
					}
				}
			}
			.frame(maxHeight: .infinity)

			Divider()

			HStack {
				TextField("Type your message...", text: $newMessage)
					.focused($isInputFocused)
					.textFieldStyle(.roundedBorder)
					.onSubmit { sendMessage() }

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


extension Publishers {
	static var keyboardHeight: AnyPublisher<CGFloat, Never> {
		let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
			.map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 }

		let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
			.map { _ in CGFloat(0) }

		return MergeMany(willShow, willHide).eraseToAnyPublisher()
	}
}


#Preview {
	ChatView(viewModel: ChatViewModel())
}
