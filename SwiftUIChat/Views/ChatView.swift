//
//  ChatView.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI
import Combine
import SwiftUIIntrospect

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel
	@State private var newMessage: String = ""
	@FocusState private var isInputFocused: Bool

	var body: some View {
		ZStack(alignment: .top) {
			VStack(spacing: 0) {
				ScrollViewReader { proxy in
					ZStack {
						ScrollView(.vertical, showsIndicators: false) {
							VStack(spacing: 8) {
								ForEach(viewModel.messages) { message in
									MessageView(message: message)
										.id(message.id)
								}
							}
							
							.rotationEffect(.degrees(180))
							.padding(.vertical, 12)
							.padding(.horizontal)
						}
						.rotationEffect(.degrees(180))
						.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18)) { scrollView in //TODO: add iOS 26
							//disables scrollToTop if tapped on top of the screen, because ScrollView is rotated
							scrollView.scrollsToTop = false
						}

						.overlay(alignment: .top) {
							LinearGradient(
								colors: [.topEdgeGradient, .clear],
								startPoint: .top,
								endPoint: .bottom
							)
							.frame(height: 120)
							.allowsHitTesting(true)
						}

						.onTapGesture { isInputFocused = false }
						.onChange(of: viewModel.messages.count) { _ in
							scrollToLastMessage(using: proxy)
						}
						.onAppear {
							scrollToLastMessage(using: proxy)
						}
					}
				}
				.ignoresSafeArea(.all, edges: .top)

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
	}



	private func sendMessage() {
		let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }

		viewModel.addMessage(text: trimmed)
		newMessage = ""
		isInputFocused = true
	}

	private func scrollToLastMessage(using proxy: ScrollViewProxy) {
		guard let lastID = viewModel.messages.last?.id else { return }
		DispatchQueue.main.async {
			withAnimation {
				proxy.scrollTo(lastID, anchor: .bottom)
			}
		}
	}
}

//#Preview {
//	ChatView(viewModel: ChatViewModel())
//}
