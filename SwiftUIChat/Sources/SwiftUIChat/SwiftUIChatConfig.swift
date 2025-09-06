// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// MARK: - Public Configuration
public struct ChatConfiguration {
	public let localUserID: Int
	public let chatID: Int
//	public let allowsMessageInput: Bool
//	public let maxMessageLength: Int

	public init(
		localUserID: Int = 0,
		chatID: Int = 0,
//		allowsMessageInput: Bool = true,
//		maxMessageLength: Int = 500
	) {
		self.localUserID = localUserID
		self.chatID = chatID
//		self.allowsMessageInput = allowsMessageInput
//		self.maxMessageLength = maxMessageLength
	}
}

// MARK: - Public Factory Methods
public extension ChatView {
	static func create(with configuration: ChatConfiguration = ChatConfiguration()) -> ChatView {
		let viewModel = ChatViewModel()
		viewModel.localUserID = configuration.localUserID
		viewModel.chatID = configuration.chatID
		return ChatView(viewModel: viewModel)
	}
}

// MARK: - Public Theme Support
//public struct ChatTheme {
//	public var userBackgroundColor: Color
//	public var partnerBackgroundColor: Color
//	public var userTextColor: Color
//	public var partnerTextColor: Color
//
//	public init(
//		userBackgroundColor: Color = .blue,
//		partnerBackgroundColor: Color = .gray,
//		userTextColor: Color = .white,
//		partnerTextColor: Color = .black
//	) {
//		self.userBackgroundColor = userBackgroundColor
//		self.partnerBackgroundColor = partnerBackgroundColor
//		self.userTextColor = userTextColor
//		self.partnerTextColor = partnerTextColor
//	}
//
//	@MainActor public static let `default` = ChatTheme()
//}
