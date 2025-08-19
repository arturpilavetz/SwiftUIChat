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
						.padding(12)
						.background(message.type.backgroundColor)
						.foregroundStyle(message.type.textColor)
						.cornerRadius(23)
						.multilineTextAlignment(message.type.textAlignment)
					Text("\(message.timestamp)")
						.font(.system(size: 12))
						.padding(.horizontal, 12)
				}
				.frame(maxWidth: 250, alignment: message.type.hAlignment)

				if message.type != .user { Spacer() }
			}
			.padding(.horizontal)

		}
    }
	
}
