// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// MARK: - Public Configuration
public struct ChatConfiguration {
	public let userID: Int
	public let allowsMessageInput: Bool
	public let maxMessageLength: Int

	public init(
		userID: Int = 12345,
		allowsMessageInput: Bool = true,
		maxMessageLength: Int = 500
	) {
		self.userID = userID
		self.allowsMessageInput = allowsMessageInput
		self.maxMessageLength = maxMessageLength
	}
}

// MARK: - Public Factory Methods
public extension ChatView {
	/// Creates a ChatView with default configuration
	static func create(with configuration: ChatConfiguration = ChatConfiguration()) -> ChatView {
		let viewModel = ChatViewModel()
		viewModel.userID = configuration.userID
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
