//
//  SwiftUIChatExampleApp.swift
//  SwiftUIChatExample
//
//  Created by Artur Pilavetz on 04.09.2025.
//

import SwiftUI
import SwiftUIChat

@main
struct SwiftUIChatExampleApp: App {
	var body: some Scene {
		WindowGroup {
			ChatView.create()
		}
	}
}
