//
//  ChatViewModel.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI

@MainActor
public class ChatViewModel: ObservableObject {
	@Published public var messages = [ChatMessage]()
	public var localUserID = 0
	public var chatID = 0


	public init() {

	}

	func addMessage(text: String) {
		let message = ChatMessage(
			chatId: chatID,
			userId: localUserID,
			message: text,
			timestamp: Date().timeIntervalSince1970,
			localUserID: localUserID
		)
		messages.append(message)
	}
}
