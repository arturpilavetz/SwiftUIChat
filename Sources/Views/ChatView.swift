//
//  ChatView.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI
import Combine
import SwiftUIIntrospect

public struct ChatView: View {
	@StateObject var viewModel: ChatViewModel
	@FocusState private var isInputFocused: Bool
	@State private var newMessage: String = ""
	@State private var safeAreaTopHeight: CGFloat = 0
	@State private var safeAreaBottomHeight: CGFloat = 0
	@State private var textFieldHeight: CGFloat = 0

	private let textFieldInsets: CGFloat = 10

	public init(viewModel: ChatViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	//TODO: add a butoon with popup animation to scroll to top, presents animated when scrolled from bottom for the height of a MessageView min height
	public var body: some View {
		ZStack(alignment: .bottom) {
			ScrollViewReader { proxy in
				ScrollView(.vertical, showsIndicators: false) {
					LazyVStack(spacing: 8) {
						ForEach(viewModel.messages) { message in
							MessageView(message: message)
								.id(message.id)
						}
					}
					.padding(.top, safeAreaTopHeight)
					.padding(.bottom, textFieldHeight + safeAreaBottomHeight + textFieldInsets)
					.rotationEffect(.degrees(180))
					.padding(.vertical, 12)
					.padding(.horizontal)
				}
				.rotationEffect(.degrees(180))
				.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { scrollView in
					//disables scrollToTop if tapped on top of the screen, because ScrollView is rotated
					scrollView.scrollsToTop = false
					scrollView.keyboardDismissMode = .interactive
				}
				.onTapGesture { isInputFocused = false }
				.onChange(of: viewModel.messages.count) { _ in
					scrollToLastMessage(using: proxy)
				}
				.onAppear {
					if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
					   let window = windowScene.windows.first(where: \.isKeyWindow) {
						safeAreaTopHeight = window.safeAreaInsets.top
						safeAreaBottomHeight = window.safeAreaInsets.bottom
					}

					scrollToLastMessage(using: proxy)
				}
				.overlay(alignment: .top) {
					LinearGradient(
						colors: [.topEdgeGradient, .clear],
						startPoint: .top,
						endPoint: .bottom
					)
					.frame(height: safeAreaTopHeight)
					.allowsHitTesting(false)
				}
				.overlay(alignment: .bottom) {
					LinearGradient(
						colors: [.topEdgeGradient, .clear],
						startPoint: .bottom,
						endPoint: .top
					)
					.frame(height: textFieldHeight + safeAreaBottomHeight + textFieldInsets)
					.allowsHitTesting(false)
				}
			}
			.ignoresSafeArea(.all, edges: [.top])
			.padding(.bottom, -safeAreaBottomHeight) //is made to get scrollView get to the screen bottom as well as with the keyboard functionality

			ChatInputBar(
				text: $newMessage,
				isInputFocused: _isInputFocused,
				textFieldHeight: $textFieldHeight,
				textFieldInsets: textFieldInsets,
				allowsMessageInput: viewModel.allowsMessageInput,
				onSend: sendMessage
			)
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
