//
//  ChatMessage.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI

public struct ChatMessage: Identifiable, Equatable {
	public let id = UUID()
	let chatId: Int?
	let userId: Int
	let timestamp: Double
	let message: String

	let type: MessageContentType

	var sentDate: Date {
		Date(timeIntervalSince1970: timestamp)
	}

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case chatId = "chat_id"
		case userId = "user_id"
		case timestamp
		case message
	}

	public init(chatId: Int? = nil, userId: Int, message: String, timestamp: Double = Date().timeIntervalSince1970, localUserID: Int) {
		self.chatId = chatId
		self.userId = userId
		self.message = message
		self.timestamp = timestamp
		
		if userId == localUserID {
			self.type = .user
		} else {
			self.type = .partner
		}
	}
}
