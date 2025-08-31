//
//  File.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI

struct ChatMessage: Identifiable, Equatable {
	struct Sender {
		var id: String
		var displayName: String
	}


//	var id: Int?
	let id = UUID()
	var chatId: Int?
	let userId: Int
	let timestamp: Double
	let message: String

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

	init(chatId: Int? = nil, userId: Int, message: String, timestamp: Double = Date().timeIntervalSince1970) {
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

enum MessageContentType {
	case user, partner

	var backgroundColor: Color {
		switch self {
			case .user:
				return .userBackground
			case .partner:
				return .partnerBackground
		}
	}

	var textColor: Color {
		switch self {
			case .user:
				return .white
			case .partner:
				return .partnerText
		}
	}

	var textAlignment: TextAlignment {
		switch self {
			case .user:
				return .trailing
			case .partner:
				return .leading
		}
	}


	var hAlignment: Alignment {
		switch self {
			case .user: return .trailing
			case .partner: return .leading
		}
	}
}

