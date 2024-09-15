//
//  Extension+HapticFeedback.swift
//  Extensions
//
//  Created by ilker on 7.09.2024.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct HapticFeedbackModifier: ViewModifier {
    let feedbackStyle: SensoryFeedbackWrapper
    @Binding var trigger: Int
    
    func body(content: Content) -> some View {
#if os(iOS)
        content
            .modifier(ConditionalSensoryFeedbackModifier(feedbackStyle: feedbackStyle, trigger: $trigger))
#else
        content
        
#endif
    }

}

#if os(iOS)
struct ConditionalSensoryFeedbackModifier: ViewModifier {
    let feedbackStyle: SensoryFeedbackWrapper
    @Binding var trigger: Int
    @State private var oldTriggerValue: Int = 0

    @available(iOS 17.0, *)
    private var sensoryFeedbackStyle: SensoryFeedback {
        switch feedbackStyle {
        case .success:
            return .success
         case .warning:
            return .warning
         case .error:
            return .error
         case .selection:
            return .selection
         case .increase:
            return .increase
         case .decrease:
            return .decrease
         case .start:
            return .start
         case .stop:
            return .stop
         case .alignment:
            return .alignment
         case .levelChange:
            return .levelChange
        }
    }
    
    private var oldFeedbackStyle: UINotificationFeedbackGenerator.FeedbackType {
        switch feedbackStyle {
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        @unknown default:
            return .success
        }
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.sensoryFeedback(sensoryFeedbackStyle, trigger: trigger)
        } else {
            content
                .onChange(of: trigger) { newValue in
                    if newValue != oldTriggerValue {
                        oldTriggerValue = newValue
                        generateHapticFeedback()
                    }
                }
        }
    }

    private func generateHapticFeedback() {
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(oldFeedbackStyle)
    }
}
#endif

public enum SensoryFeedbackWrapper {
    case success
    case warning
    case error
    case selection
    case increase
    case decrease
    case start
    case stop
    case alignment
    case levelChange
}

extension View {
     public func hapticFeedback(style: SensoryFeedbackWrapper, trigger: Binding<Int>) -> some View {
        self.modifier(HapticFeedbackModifier(feedbackStyle: style, trigger: trigger))
    }
}
