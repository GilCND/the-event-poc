//
//  Logger+Category.swift
//  theevent-poc
//
//  Created by Felipe Gil on 2023-10-21.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    static let viewModel = Logger(subsystem: subsystem, category: "viewmodel")
}
