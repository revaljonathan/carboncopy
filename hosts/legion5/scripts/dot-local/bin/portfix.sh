#!/usr/bin/env bash

# run this to fix my portal for obs 

pkill obs

systemctl --user stop xdg-desktop-portal
systemctl --user stop xdg-desktop-portal-gnome
systemctl --user stop xdg-desktop-portal-gtk

systemctl --user start xdg-desktop-portal-gnome
systemctl --user start xdg-desktop-portal
