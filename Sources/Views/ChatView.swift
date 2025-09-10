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


	@State private var scrollViewContentHeight: CGFloat = 0

	// Back to top button states
	@State private var scrollOffset: CGPoint = .zero
	@State private var showBackToTopButton: Bool = false
	private let minimumScrollOffset: CGFloat = -278
	private let coordinateSpaceName = "ChatScrollView"

	private let textFieldInsets: CGFloat = 10

	public init(viewModel: ChatViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}

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
					.background(
						// Position observer to track scroll
						ChatPositionObservingView(
							coordinateSpace: .named(coordinateSpaceName),
							position: Binding(
								get: { scrollOffset },
								set: { newOffset in
									scrollOffset = CGPoint(
										x: -newOffset.x,
										y: -newOffset.y
									)
								}
							)
						)
					)

					.overlay(
						GeometryReader { proxy in
							Color.clear
								.onAppear {
									scrollViewContentHeight = proxy.size.height
								}
								.onChange(of: viewModel.messages) { _ in
									scrollViewContentHeight = proxy.size.height
								}
						}
					)
				}
				.rotationEffect(.degrees(180))
				.coordinateSpace(name: coordinateSpaceName)
				.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { scrollView in
					//disables scrollToTop if tapped on top of the screen, because ScrollView is rotated
					scrollView.scrollsToTop = false
					scrollView.keyboardDismissMode = .interactive
				}
				.onTapGesture { isInputFocused = false }
				.onChange(of: viewModel.messages.count) { _ in
					scrollToLastMessage(using: proxy)
				}
				.onChange(of: scrollOffset.y) { newValue in
					withAnimation(.easeInOut(duration: 0.3)) {

//						let ttt = scrollViewContentHeight - keyboard

						if newValue < minimumScrollOffset && !showBackToTopButton {
							showBackToTopButton = true
						} else if newValue >= minimumScrollOffset && showBackToTopButton {
							showBackToTopButton = false
						}

//						print(" showBackToTopButton \(showBackToTopButton) \(newValue)")
						print("*** scrollOffset: \(newValue), contentHeight: \(scrollViewContentHeight)")

					}
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
//				 Back to latest button overlay (temporarily always visible for debugging)
				.overlay(alignment: .topTrailing) {
					if showBackToTopButton {
						Button {
							print("Button tapped!")
							scrollToLastMessage(using: proxy)
						} label: {
							HStack(spacing: 4) {
								Image(systemName: "arrow.down")
									.font(.system(size: 12, weight: .semibold))
								Text("Latest")
									.font(.system(size: 12, weight: .medium))
							}
							.foregroundStyle(.white)
							.padding(.horizontal, 12)
							.padding(.vertical, 8)
							.background(
								Capsule()
									.fill(showBackToTopButton ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
							)
						}
						.padding(.top, safeAreaTopHeight + 16)
						.padding(.trailing, 16)
						.buttonStyle(ChatButtonPressStyle())
					}
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
			withAnimation(.easeInOut(duration: 0.6)) {
				proxy.scrollTo(lastID, anchor: .bottom)
			}
		}
	}
}

// MARK: - Chat Position Observer
struct ChatPositionObservingView: View { //TODO: look if we can fit in here a scrollViewContentHeight
	var coordinateSpace: CoordinateSpace
	@Binding var position: CGPoint

	var body: some View {
		Color.clear
			.frame(height: 0)
			.background(GeometryReader { geometry in
				Color.clear.preference(
					key: ChatScrollOffsetPreferenceKey.self,
					value: geometry.frame(in: coordinateSpace).origin
				)
			})
			.onPreferenceChange(ChatScrollOffsetPreferenceKey.self) { position in
				self.position = position
			}
	}
}

// MARK: - Supporting Types
struct ChatScrollOffsetPreferenceKey: PreferenceKey {
	nonisolated(unsafe) static var defaultValue: CGPoint = .zero
	static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
		value = nextValue()
	}
}

struct ChatButtonPressStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
			.animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
	}
}
