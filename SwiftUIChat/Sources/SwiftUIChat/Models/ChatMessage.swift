//
//  ChatMessage.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI

public struct ChatMessage: Identifiable, Equatable {
	struct Sender {
		var id: String
		var displayName: String
	}

	public let id = UUID()
	public var chatId: Int?
	public let userId: Int
	public let timestamp: Double
	public let message: String

	var sender: Sender {
		Sender(id: "\(userId)", displayName: "")
	}
//	var messageId: String

	var sentDate: Date {
		Date(timeIntervalSince1970: timestamp)
	}

	var type: MessageContentType

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case chatId = "chat_id"
		case userId = "user_id"
		case timestamp
		case message
	}

	public init(chatId: Int? = nil, userId: Int, message: String, timestamp: Double = Date().timeIntervalSince1970) {
		self.chatId = chatId
		self.userId = userId
		self.message = message
		self.timestamp = timestamp


		if userId == 12345 {
			self.type = .user
		} else {
			self.type = .partner
		}
	}
}
