# MXE (M cross environment) - for ARM32 Windows development

This is a modified version of MXE that comes with fixed scripts and sources that way Windows on ARM32 can have proper development for it.

MXE (M cross environment) is a GNU Makefile that compiles a cross
compiler and cross compiles many free libraries such as SDL and
Qt. Thus, it provides a nice cross compiling environment for
various target platforms, which:

  * is designed to run on any Unix system
  * is easy to adapt and to extend
  * builds many free libraries in addition to the cross compiler
  * can also build just a subset of the packages, and automatically builds their dependencies
  * downloads all needed packages and verifies them by their checksums
  * is able to update the version numbers of all packages automatically
  * directly uses source packages, thus ensuring the whole build mechanism is transparent
  * allows inter-package and intra-package parallel builds whenever possible
  * bundles [ccache](https://ccache.samba.org) to speed up repeated builds
  * integrates well with autotools, cmake, qmake, and hand-written makefiles.

## Supported Toolchains

  * Runtime: LLVM (Clang)
  * Host Triplets:
    - `armv7-w64-mingw32`

This version of MXE is meant for specifically Windows on ARM32 porting only, but to just add on to it, ports can be unstable, so some packages may not build properly. For Aarch64 development, check [the Aarch64 development repos](https://github.com/aarch64devel/mxe) once they're updated again.

## Setting up

To use this for ARM development easily, first clone this repository to your home directory on any Linux system. [Be sure you have the dependencies installed from the site already](https://mxe.cc/#requirements). Then, download a zip of the current release of LLVM-MinGW (preferably from [here](https://github.com/armdevvel/llvm-mingw/releases)).

After this, you'll need to add MXE to your path and restart your terminal. For this example, I'll add it to Bash. In `~/.bashrc`, I would add the following for my home directory.

```bash
export PATH=$HOME/armmxe-shared/usr/bin:$PATH
```

Now, in your terminal after restarting, cd to the MXE directory. Then, run `make cc`. This will install the toolchain (pre-built, does not build itself) and allow you to be able to build other packages without the need of waiting for `cc`/`llvm-mingw`/etc.

You should be good to go now! Go have fun with your heart's desires building what you can/please. If there's issues, never be afraid to ask for help by opening an issue.

## Building (configuring) with each build system

  * Autoconf:
    - Use `./configure --host=armv7-w64-mingw32 --prefix=/home/youruser/armmxe-unstable/usr/armv7-w64-mingw32`
  * Meson:
    - Build `meson-wrapper` and use `armv7-w64-mingw32-meson` provided by MXE
  * CMake:
    - Build `cmake-conf` and use `armv7-w64-mingw32-cmake` provided by MXE
  * normal make:
    - For projects that still use this way for some reason, use `make CC=armv7-w64-mingw32-gcc CXX=armv7-w64-mingw32-g++ LD=armv7-w64-mingw32-ld AR=armv7-w64-mingw32-ar AS=armv7-w64-mingw32-as`
  * MXE:
    - This stays the same, but instead of a host triplet being `i686-w64-mingw32` or `x86_64-w64-mingw32`, you just run make with the package you want. Basically, run `make package`

## Things you should probably know

When you build applications and run them on Windows on ARM (32 or 64), you might need the UCRT files. It may be included, but some OSes (such as RT8.1 without all updates) do not have it. For the ARM32 UCRT DLLs, you can snatch them [here](resources/WinUCRT.tar.xz).

## FAQ

Q: Will this work on WSL?  \
A: Yes! I would *recommend* using Ubuntu for this repo if you're using WSL.

Q: Do I need to have a specific distro? \
A: Nope! This is meant for any distro that normal MXE can use, this repo just comes with patches and extras for ARM32 Windows development.

Q: What if I have trouble with a package while building for ARM32? \
A: You can open an issue here, or try to fix it yourself if you wanted to. We may be busy, but we will get to your issue as soon as we possibly can!

Q: What if I have more questions?? \
A: As said, don't be afraid to open an issue for help. If the question is a good one, we will put it here that way more people do not have to dig through issues for help.

Q: So what libraries DO/DON'T work? (ARM question) \
A: Check [this spreadsheet](https://docs.google.com/spreadsheets/d/1Z3FsGSXh3eOh3D9pcrw8rqQk3W11A8DudYqaO8XoQF0/edit?usp=sharing). It's updated when we fix things and gives reasons as to why packages may not build.

Q: So... are we getting an RT browser? \
A: Yes..! To an extent. -ish. The quickest way to explain is that Windows RT (8/8.1) only runs things in THUMB2 mode, meaning it cannot run things such as ARM32 JIT, which makes browsing the web painfully slow. However, the leaked Windows 10 on ARM32 image has no limitations on the CPU (doesn't run in THUMB2 mode) and can run normal ARM32 code. We can build WebKit without JIT, but it is MUCH slower. The best bet is to just upgrade to Windows 10 on ARM32. It's faster, and it allows for much more opportunity, but we know not all people can or want to, so therefore we will maintain a JIT-less QtWebKit. We've got you covered, RT8.1 users! (Users wondering about just writing a JIT in THUMB2, go check [issue 1 on the other MXE repo](https://github.com/armdevvel/mxe/issues/1). It's a discussion, should give a little insight as to thoughts from us.)

# Original README

[Check here](OGREADME.md)

# Credits

A lot of this wouldn't have been possible without the help of some patches from [libvips](https://github.com/libvips/build-win64-mxe). Thank you, libvips developers.
