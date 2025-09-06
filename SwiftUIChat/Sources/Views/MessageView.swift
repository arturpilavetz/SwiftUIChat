//
//  MessageView.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 27.08.2025.
//

import SwiftUI

struct MessageView: View {
	init(message: ChatMessage) {
		self.message = message
	}

	private let message: ChatMessage

    var body: some View {
		VStack {
			HStack {
				if message.type == .user { Spacer() }

				VStack(alignment: message.type.hAlignment.horizontal, spacing: 4) {
					Text(message.message)
						.padding(.leading, message.type == .user ? 12 : 17)
						.padding(.trailing, message.type == .user ? 17 : 12)
						.padding(.top, 12)
						.padding(.bottom, 12)
						.background(message.type.backgroundColor)
						.clipShape(MessageShape(type: message.type))
						.foregroundColor(message.type.textColor)

					Text(Date(timeIntervalSince1970: message.timestamp), format: .dateTime.hour().minute())
						.font(.system(size: 12))
						.padding(.horizontal, 12)
				}
				.frame(maxWidth: 250, alignment: message.type.hAlignment)

				if message.type != .user { Spacer() }
			}
		}
    }
}
