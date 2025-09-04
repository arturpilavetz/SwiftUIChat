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
	@StateObject private var viewModel = ChatViewModel()

	var body: some Scene {
		WindowGroup {
			ChatView(viewModel: viewModel)
				.onAppear {
					viewModel.localUserID = 67890
					loadMessages()
				}
		}
	}

	private func loadMessages() {
		viewModel.messages = [
			ChatMessage(userId: 67890, message: "Hello!", timestamp: Date().timeIntervalSince1970, localUserID: viewModel.localUserID),
			ChatMessage(userId: 12345, message: "Hi there!", timestamp: Date().timeIntervalSince1970, localUserID: viewModel.localUserID)
		]
	}
}
