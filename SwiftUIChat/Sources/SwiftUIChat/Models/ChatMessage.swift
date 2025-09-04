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

		public init(id: String, displayName: String) {
			self.id = id
			self.displayName = displayName
		}
	}

	public let id = UUID()
	public var chatId: Int?
	public let userId: Int
	public let timestamp: Double
	public let message: String

	public let type: MessageContentType

	var sender: Sender {
		Sender(id: "\(userId)", displayName: "")
	}

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
