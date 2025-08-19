//
//  ChatViewModel.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
	@Published var messages = [ChatMessage]()

	let userID = 12345

	init() {
		setMessages()
	}

	func setMessages() {
		messages = [
			ChatMessage(id: 1, chatId: 1001, userId: 12345, message: "First", timestamp: 12345678),
			ChatMessage(id: 2, chatId: 1001, userId: 12345, message: "2", timestamp: 12345679),
			ChatMessage(id: 3, chatId: 1001, userId: 56789, message: "3", timestamp: 12345690),
			ChatMessage(id: 4, chatId: 1001, userId: 56789, message: "4", timestamp: 12345691),
			ChatMessage(id: 5, chatId: 1001, userId: 12345, message: "5", timestamp: 12345678),
			ChatMessage(id: 6, chatId: 1001, userId: 12345, message: "6", timestamp: 12345679),
			ChatMessage(id: 7, chatId: 1001, userId: 56789, message: "7", timestamp: 12345690),
			ChatMessage(id: 8, chatId: 1001, userId: 56789, message: "8", timestamp: 12345691),
			ChatMessage(id: 9, chatId: 1001, userId: 12345, message: "9", timestamp: 12345678),
			ChatMessage(id: 10, chatId: 1001, userId: 12345, message: "10", timestamp: 12345679),
			ChatMessage(id: 11, chatId: 1001, userId: 56789, message: "11", timestamp: 12345690),
			ChatMessage(id: 12, chatId: 1001, userId: 56789, message: "Last", timestamp: 12345691),

		]
	}

	func addMessage(text: String) {
		let message = ChatMessage(
			id: messages.count + 1,
			chatId: 1001,
			userId: userID,
			message: text,
			timestamp: Date().timeIntervalSince1970
		)
		messages.append(message)
	}

//	func insertMessage() {
//		Task {
//			try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
//			messages.append(ChatMessage(
//				id: messages.count + 1,
//				chatId: 1001,
//				userId: userID,
//				message: "New user message",
//				timestamp: Date().timeIntervalSince1970
//			))
//		}
//	}


}
