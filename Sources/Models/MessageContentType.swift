//
//  File.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 02.08.2025.
//

import SwiftUI

public enum MessageContentType: Sendable {
	case user, partner

	public var backgroundColor: Color {
		switch self {
			case .user:
				return .userBackground
			case .partner:
				return .partnerBackground
		}
	}

	public var textColor: Color {
		switch self {
			case .user:
				return .white
			case .partner:
				return .partnerText
		}
	}

	public var textAlignment: TextAlignment {
		switch self {
			case .user:
				return .trailing
			case .partner:
				return .leading
		}
	}

	public var hAlignment: Alignment {
		switch self {
			case .user:
				return .trailing
			case .partner:
				return .leading
		}
	}
}
