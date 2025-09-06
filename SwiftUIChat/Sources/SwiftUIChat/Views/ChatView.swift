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
					VStack(spacing: 8) {
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

			if #available(iOS 26.0, *) {
				VStack {
					Spacer()

					HStack {
						TextField("Type your message...", text: $newMessage, axis: .vertical)
							.lineLimit(1...5)
							.focused($isInputFocused)
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
				.padding(.bottom, textFieldInsets)
				.padding([.leading, .trailing], textFieldInsets)
			} else { // iOS 15-18 support
				VStack {
					Spacer()

					HStack {
						ZStack(alignment: .topLeading) {
							TextEditor(text: $newMessage)
								.frame(minHeight: 36, maxHeight: 120)
								.fixedSize(horizontal: false, vertical: true)
								.focused($isInputFocused)
								.clipped()
								.clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

								.introspect(.textEditor, on: .iOS(.v15, .v16, .v17, .v18)) { textEditor in
									textEditor.backgroundColor = .clear
								}
							if newMessage.isEmpty {
								Text("Type your message...")
									.foregroundColor(.gray)
									.padding(.horizontal, 4)
									.padding(.vertical, 8)
									.allowsHitTesting(false)
							}
						}

						Button(action: sendMessage) {
							Image(systemName: "paperplane.fill")
								.rotationEffect(.degrees(45))
								.padding(.leading, 8)
						}
						.disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
				.padding(.bottom, textFieldInsets)
				.padding([.leading, .trailing], textFieldInsets)

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
