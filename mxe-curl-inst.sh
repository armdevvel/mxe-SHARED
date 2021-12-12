cd ~
echo "Clone MXE from my source that way ARM is included :)"
git clone https://github.com/armdevvel/mxe --depth=1
echo "cd mxe!"
cd mxe
echo "Download LLVM-MinGW!"
mkdir usr && cd usr && wget https://github.com/armdevvel/llvm-mingw/releases/download/13.0/armv7-only-llvm-mingw-linux-x86_64.tar.xz
echo "Extract LLVM-MinGW!"
tar -xf armv7-only-llvm-mingw-linux-x86_64.tar.xz
echo "Setup known packages that work! This may take a while... Hold on tight!~"
cd .. && make MXE_TARGETS="armv7-w64-mingw32" libpng cmake sdl2 sdl tiff jpeg ccache lame libxml++ libxml2 libxslt libyaml libzip libwebp libusb1 sdl_image sdl_mixer sdl2_mixer zlib yasm dbus pcre boost icu4c
echo "Adding MXE to your PATH (bash)"
echo "\n" >> ~/.bashrc
echo "export PATH = /home/$USER/mxe/usr/bin"':$PATH' >> ~/.bashrc
echo "Finished!"