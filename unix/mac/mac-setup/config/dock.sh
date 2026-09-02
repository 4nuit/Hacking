#!/usr/bin/env bash
#
# config/dock.sh
#
# Dock and menu bar settings, taken from a real Mac with
# lib/export-dock.sh on 2026-09-02. These are the values that machine
# actually had, not defaults picked by hand.
#
# The dock stage runs this AFTER omacosy, so what is here wins over
# anything omacosy sets. The trackpad stage runs before omacosy, for the
# opposite reason: there omacosy has to win, because it needs the
# four-finger gestures free for its own swipe daemon.
#
# If config/dock/ exists, written by lib/export-dock.sh --write, the
# stage uses that directory instead of this file and copies the types
# exactly. This file is the fallback.
#
# Delete any line you do not want.

set -uo pipefail

# --- Dock ------------------------------------------------------------

defaults write com.apple.dock orientation -string bottom
defaults write com.apple.dock autohide -bool true

# Icon size, and the size under the pointer when magnification is on.
defaults write com.apple.dock tilesize -int 34
defaults write com.apple.dock largesize -int 90
defaults write com.apple.dock magnification -bool true

# Do not add recently used apps to the right of the Dock.
defaults write com.apple.dock show-recents -bool false

# autohide-delay and autohide-time-modifier are deliberately absent.
# The source machine leaves both unset, so the Dock uses the macOS
# defaults. Setting them to 0 makes the Dock appear the instant the
# pointer touches the edge, which is quicker but also makes it appear
# when you did not mean it to. Uncomment if you want that.
# defaults write com.apple.dock autohide-delay -float 0
# defaults write com.apple.dock autohide-time-modifier -float 0.15

# --- Hot corners -----------------------------------------------------
#
# Two corners are set, and both are set to 1, which is the value for no
# action. On recent macOS the bottom right corner defaults to Quick
# Note, so this is how you switch that off. The other two corners are
# left unset, which means they keep whatever the system default is.
#
# The modifier is 0, meaning the corner acts with no key held down.

defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

# --- Menu bar --------------------------------------------------------
#
# _HIHideMenuBar hides the menu bar until the pointer reaches the top of
# the screen. AutoHideMenuBarOption is the newer Control Centre setting
# that sits alongside it; 0 is the always-hide option.
#
# This pairs with omacosy, which draws its own status bar showing the
# clock, battery, wi-fi and workspaces. Without omacosy running you lose
# sight of all of those until you move the pointer up, so comment these
# out if you are not using the desktop.

defaults write -g _HIHideMenuBar -bool true
defaults write -g AppleMenuBarVisibleInFullscreen -bool false
defaults write com.apple.controlcenter AutoHideMenuBarOption -int 0

# --- What shows in the menu bar --------------------------------------
#
# Only the named items are copied. The source machine also had eight
# entries called Item-0 to Item-7, all hidden. Those are anonymous slots
# belonging to third-party apps in the order that machine happened to
# install them. On another Mac the same numbers point at different apps,
# or at nothing, so copying them would hide the wrong things.

defaults write com.apple.controlcenter "NSStatusItem Visible BentoBox" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool false
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Battery" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Clock" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC WiFi" -bool true

# Per machine. 8 means the item stays in Control Centre and out of the
# menu bar. These four are copied as read rather than translated,
# because the numbers are not documented by Apple.
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
defaults -currentHost write com.apple.controlcenter Bluetooth -int 8
defaults -currentHost write com.apple.controlcenter NowPlaying -int 8
defaults -currentHost write com.apple.controlcenter VoiceControl -int 8
defaults -currentHost write com.apple.controlcenter AirplayRecieverEnabled -bool false
defaults -currentHost write com.apple.controlcenter ShowSuggestions -bool true

# NSStatusItem Preferred Position keys are not copied. They are pixel
# offsets from the right edge, and they depend on screen width and on
# which items exist. Replaying them on a different display puts things
# in the wrong place.

# --- Clock -----------------------------------------------------------

defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock TimeAnnouncementsEnabled -bool false

# --- Apply -----------------------------------------------------------
#
# Each of these re-reads its settings only when it restarts. Restarting
# them is instant and safe; launchd starts them again straight away.

killall Dock 2>/dev/null || true
killall ControlCenter 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
