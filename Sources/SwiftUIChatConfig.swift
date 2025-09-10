//
//  SwiftUIChatConfig.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 10.09.2025.
//

import SwiftUI

// MARK: - Public Configuration
public struct ChatConfiguration {
	public let localUserID: Int
	public let chatID: Int
	public let allowsMessageInput: Bool

	public init(
		localUserID: Int = 0,
		chatID: Int = 0,
		allowsMessageInput: Bool = true,
	) {
		self.localUserID = localUserID
		self.chatID = chatID
		self.allowsMessageInput = allowsMessageInput
	}
}

// MARK: - Public Factory Methods
public extension ChatView {
	static func create(with configuration: ChatConfiguration, viewModel: ChatViewModel? = nil) -> ChatView {
		let vm = viewModel ?? ChatViewModel()
		vm.localUserID = configuration.localUserID
		vm.chatID = configuration.chatID
		vm.allowsMessageInput = configuration.allowsMessageInput
		return ChatView(viewModel: vm)
	}
}
