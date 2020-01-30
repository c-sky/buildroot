# Buildroot
For T-HEAD XuanTie CPU Series

# Introduction
Buildroot is a tool that simplifies and automates the process of building a complete Linux system for an embedded system, using cross-compilation. In order to achieve this, Buildroot is able to generate a cross-compilation toolchain, a root filesystem, a Linux kernel image and a bootloader for your target. Buildroot can be used for any combination of these options, independently (you can for example use an existing cross-compilation toolchain, and build only your root filesystem with Buildroot).

T-Head buildroot is based on buildroot.org and make some project-specific customizations for XuanTie CPU Series' opensource ecosystem.

# Quick Start
https://github.com/c-sky/buildroot/releases

# Merge Rules
1: Every monday is our merge window. Please rebase your patch on the version of last monday.

2: Please make a merge request through gitlab when your patch passed all of the tests.

3: Please write a detail and useful commit message for your patch.

4: Please send you patch to linux@c-sky.com for review.

