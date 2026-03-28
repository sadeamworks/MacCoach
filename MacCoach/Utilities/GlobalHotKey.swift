import Carbon
import AppKit

final class GlobalHotKey: @unchecked Sendable {
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    nonisolated(unsafe) private static var sharedAction: (() -> Void)?

    /// Registers Ctrl+Shift+M as a global hotkey to toggle the popover.
    init(action: @escaping @Sendable () -> Void) {
        GlobalHotKey.sharedAction = action
        register()
    }

    deinit {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
        if let eventHandler {
            RemoveEventHandler(eventHandler)
        }
        GlobalHotKey.sharedAction = nil
    }

    private func register() {
        let modifiers: UInt32 = UInt32(controlKey | shiftKey)
        let keyCode: UInt32 = 0x2E // M key

        var hotKeyID = EventHotKeyID(signature: OSType(0x4D43), id: 1)
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))

        InstallEventHandler(GetApplicationEventTarget(), { _, _, _ -> OSStatus in
            DispatchQueue.main.async {
                GlobalHotKey.sharedAction?()
            }
            return noErr
        }, 1, &eventType, nil, &eventHandler)

        RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    }
}
