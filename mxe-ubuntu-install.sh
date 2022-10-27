cd ~
echo "Install any necessary libraries (Ubuntu/apt)"
echo "sudo will be asked for, please put in your password."
echo "Enter yes when asked, unless you see something wrong with the packages you're about to install."
sudo apt update && sudo apt install \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libncurses5-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    ninja-build \
    openssl \
    p7zip-full \
    patch \
    perl \
    python2 \
    python3 \
    python3-pip \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils
echo "Install meson (as sudo)"
sudo pip3 install meson --upgrade
echo "Clone MXE from my source that way ARM is included :)"
git clone https://github.com/armdevvel/mxe-UNSTABLE --depth=1 armmxe-unstable
echo "cd mxe!"
cd armmxe-unstable
echo "Download LLVM-MinGW!"
mkdir usr && cd usr && wget https://github.com/armdevvel/llvm-mingw/releases/download/14.0/armv7-only-llvm-mingw-linux-x86_64.tar.xz
echo "Extract LLVM-MinGW!"
tar -xf armv7-only-llvm-mingw-linux-x86_64.tar.xz
rm -rf armv7-only-llvm-mingw-linux-x86_64.tar.xz
echo "Setup known packages that work! This may take a while... Hold on tight!~"
echo "This may FAIL. These have not been tested yet!"
cd .. && make libpng cmake sdl2 sdl tiff jpeg ccache lame libxml++ libxml2 libxslt libyaml libzip libwebp libusb1 sdl_image sdl_mixer sdl2_image sdl2_mixer zlib yasm dbus pcre icu4c
echo "Adding MXE to your PATH (bash)"
echo "\n" >> ~/.bashrc
echo "export PATH=/home/$USER/armmxe-unstable/usr/bin"':$PATH' >> ~/.bashrc
echo "Finished! If you're on Ubuntu 22.04, you'll need to create a link for python2 to be able to be ran as python. If you're not on Ubuntu 22.04 (20.04 LTS / etc), install python-is-python2"
