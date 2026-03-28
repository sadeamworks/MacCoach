import AppKit
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var globalHotKey: GlobalHotKey?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupPopover()
        setupGlobalHotKey()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "graduationcap.fill", accessibilityDescription: "Mac Coach")
            button.action = #selector(togglePopover)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    private func setupMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "About Mac Coach", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Mac Coach", action: #selector(quitApp), keyEquivalent: "q"))
        return menu
    }

    @objc private func showAbout() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    private func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 480)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: PopoverContentView()
        )
    }

    private func setupGlobalHotKey() {
        globalHotKey = GlobalHotKey { @Sendable [weak self] in
            MainActor.assumeIsolated {
                self?.togglePopover()
            }
        }
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        let event = NSApp.currentEvent

        // Right-click shows context menu
        if event?.type == .rightMouseUp {
            let menu = setupMenu()
            statusItem.menu = menu
            button.performClick(nil)
            // Reset menu so left-click goes back to popover
            DispatchQueue.main.async { [weak self] in
                self?.statusItem.menu = nil
            }
            return
        }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
