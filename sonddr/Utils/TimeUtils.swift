//
//  Time.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import Foundation

func prettyTimeDelta(date: Date) -> String {
    let deltaInSeconds = Date.now.timeIntervalSince(date)
    let timeDelta: String
    if (deltaInSeconds < 1 * 60) {
        timeDelta = "just now"
    }
    else if (deltaInSeconds < 3600) {
        let n = Int(floor(deltaInSeconds / 60))
        timeDelta = "\(n) minute\(n > 1 ? "s" : "") ago"
    }
    else if (deltaInSeconds < 24 * 3600) {
        let n = Int(floor(deltaInSeconds / 3600))
        timeDelta = "\(n) hour\(n > 1 ? "s" : "") ago"
    }
    else if (deltaInSeconds < 7 * 24 * 3600) {
        let n = Int(floor(deltaInSeconds / (24 * 3600)))
        timeDelta = "\(n) day\(n > 1 ? "s" : "") ago"
    }
    else if (deltaInSeconds < 30.5 * 24 * 3600) {
        let n = Int(floor(deltaInSeconds / (7 * 24 * 3600)))
        timeDelta = "\(n) week\(n > 1 ? "s" : "") ago"
    }
    else if (deltaInSeconds <= 12 * 30.5 * 24 * 3600) {
        let n = Int(floor(deltaInSeconds / (30.5 * 24 * 3600)))
        timeDelta = "\(n) month\(n > 1 ? "s" : "") ago"
    }
    else {
        let n = Int(floor(deltaInSeconds / (12 * 30.5 * 24 * 3600)))
        timeDelta = "\(n) year\(n > 1 ? "s" : "") ago"
    }
    return timeDelta
}

func sleep(seconds: Double) async {
    try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
}
