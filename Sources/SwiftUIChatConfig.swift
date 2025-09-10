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
