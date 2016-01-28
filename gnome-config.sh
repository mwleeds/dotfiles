#!/bin/bash

# ensure windows have minimize, maximize, and close buttons
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# nautilus windows should default to list view sorted by most recently modified
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences default-sort-order 'mtime'
gsettings set org.gnome.nautilus.preferences default-sort-in-reverse-order true

