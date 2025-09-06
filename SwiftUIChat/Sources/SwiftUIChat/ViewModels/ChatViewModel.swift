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
//		setMessages()
	}

//	func setMessages() {
//		messages = [
////			ChatMessage(chatId: 1001, userId: 0, message: "First", timestamp: 12345678),
////			ChatMessage(chatId: 1001, userId: 0, message: "2", timestamp: 12345679),
////			ChatMessage(chatId: 1001, userId: 56789, message: "3", timestamp: 12345690),
////			ChatMessage(chatId: 1001, userId: 56789, message: "4", timestamp: 12345691),
////			ChatMessage(chatId: 1001, userId: 0, message: "5", timestamp: 12345678),
////			ChatMessage(chatId: 1001, userId: 0, message: "6", timestamp: 12345679),
////			ChatMessage(chatId: 1001, userId: 56789, message: "7", timestamp: 12345690),
////			ChatMessage(chatId: 1001, userId: 56789, message: "8", timestamp: 12345691),
////			ChatMessage(chatId: 1001, userId: 0, message: "9", timestamp: 12345678),
////			ChatMessage(chatId: 1001, userId: 0, message: "10", timestamp: 12345679),
////			ChatMessage(chatId: 1001, userId: 56789, message: "11", timestamp: 12345690),
////			ChatMessage(chatId: 1001, userId: 56789, message: "Last", timestamp: 12345691),
//		]
//	}

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
