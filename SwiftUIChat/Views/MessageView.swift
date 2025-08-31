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
//			.padding(.horizontal)
		}
    }
}

struct MessageShape: Shape {
	var type: MessageContentType

	func path(in rect: CGRect) -> Path {
		let width = rect.width
		let height = rect.height

		let bezierPath = UIBezierPath()

		switch type {
			case .user:
				bezierPath.move(to: CGPoint(x: width - 20, y: height))
				bezierPath.addLine(to: CGPoint(x: 15, y: height)) // bottom left
				bezierPath.addCurve(to: CGPoint(x: 0, y: height - 15),
									controlPoint1: CGPoint(x: 8, y: height),
									controlPoint2: CGPoint(x: 0, y: height - 8))

				bezierPath.addLine(to: CGPoint(x: 0, y: 15)) // top left
				bezierPath.addCurve(to: CGPoint(x: 15, y: 0),
									controlPoint1: CGPoint(x: 0, y: 8),
									controlPoint2: CGPoint(x: 8, y: 0))

				bezierPath.addLine(to: CGPoint(x: width - 20, y: 0)) // top right
				bezierPath.addCurve(to: CGPoint(x: width - 5, y: 15),
									controlPoint1: CGPoint(x: width - 12, y: 0),
									controlPoint2: CGPoint(x: width - 5, y: 8))

				bezierPath.addLine(to: CGPoint(x: width - 5, y: height - 12))
				bezierPath.addCurve(to: CGPoint(x: width, y: height),
									controlPoint1: CGPoint(x: width - 5, y: height - 1),
									controlPoint2: CGPoint(x: width, y: height))
				bezierPath.addLine(to: CGPoint(x: width + 1, y: height))
				bezierPath.addCurve(to: CGPoint(x: width - 12, y: height - 4),
									controlPoint1: CGPoint(x: width - 4, y: height + 1),
									controlPoint2: CGPoint(x: width - 8, y: height - 1))
				bezierPath.addCurve(to: CGPoint(x: width - 20, y: height),
									controlPoint1: CGPoint(x: width - 15, y: height),
									controlPoint2: CGPoint(x: width - 20, y: height))
			case .partner:
				bezierPath.move(to: CGPoint(x: 20, y: height))
				bezierPath.addLine(to: CGPoint(x: width - 15, y: height))
				bezierPath.addCurve(to: CGPoint(x: width, y: height - 15),
									controlPoint1: CGPoint(x: width - 8, y: height),
									controlPoint2: CGPoint(x: width, y: height - 8))
				bezierPath.addLine(to: CGPoint(x: width, y: 15))
				bezierPath.addCurve(to: CGPoint(x: width - 15, y: 0),
									controlPoint1: CGPoint(x: width, y: 8),
									controlPoint2: CGPoint(x: width - 8, y: 0))
				bezierPath.addLine(to: CGPoint(x: 20, y: 0))
				bezierPath.addCurve(to: CGPoint(x: 5, y: 15),
									controlPoint1: CGPoint(x: 12, y: 0),
									controlPoint2: CGPoint(x: 5, y: 8))
				bezierPath.addLine(to: CGPoint(x: 5, y: height - 10))
				bezierPath.addCurve(to: CGPoint(x: 0, y: height),
									controlPoint1: CGPoint(x: 5, y: height - 1),
									controlPoint2: CGPoint(x: 0, y: height))
				bezierPath.addLine(to: CGPoint(x: -1, y: height))
				bezierPath.addCurve(to: CGPoint(x: 12, y: height - 4),
									controlPoint1: CGPoint(x: 4, y: height + 1),
									controlPoint2: CGPoint(x: 8, y: height - 1))
				bezierPath.addCurve(to: CGPoint(x: 20, y: height),
									controlPoint1: CGPoint(x: 15, y: height),
									controlPoint2: CGPoint(x: 20, y: height))
		}
		return Path(bezierPath.cgPath)
	}
}


//#Preview {
//	ChatView(viewModel: ChatViewModel())
//}
