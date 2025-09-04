//
//  UIColour+Extension.swift
//  SwiftUIChat
//
//  Created by Artur Pilavetz on 04.08.2025.
//

import SwiftUI

public extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
			case 3: // RGB (12-bit)
				(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
			case 6: // RGB (24-bit)
				(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
			case 8: // ARGB (32-bit)
				(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
			default:
				(a, r, g, b) = (1, 1, 1, 0)
		}

		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue:  Double(b) / 255,
			opacity: Double(a) / 255
		)
	}

	static let userBackground = Color(red: 0.204, green: 0.788, blue: 0.349)

	static let partnerBackground = Color.dynamic(
		light: Color(red: 0.914, green: 0.914, blue: 0.922),
		dark: Color(red: 0.149, green: 0.149, blue: 0.161)
	)

	static let partnerText = Color.dynamic(
		light: Color.black,
		dark: Color.white
	)

	static let topEdgeGradient = Color.dynamic(
		light: Color.white,
		dark: Color.black
	)
}

extension Color {
	static func dynamic(light: Color, dark: Color) -> Color {
		Color(UIColor { traitCollection in
			traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
		})
	}
}
