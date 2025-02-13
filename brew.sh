#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
#if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
#  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
#  chsh -s "${BREW_PREFIX}/bin/bash";
#fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install encryption tools
brew install age
brew install rage
brew install gpgme
brew install hopenpgp-tools
brew install pinentry-mac
brew install tor
brew install torsocks

# Install tools to interact with Yubico Yubikeys
brew install age-pugin-yubikey
brew install ykman
brew install yubico-piv-tool
brew install yubikey-agent
brew install ykpers

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install some taps
brew tap 1password/tap
brew tap ameshkov/tap
brew tap bell-sw/liberica
brew tap gocardless/taps
brew tap gromgit/fuse
brew tap homebrew/bundle
brew tap homebrew/services
brew tap lencx/chatgpt
brew tap popcorn-official/popcorn-desktop
brew tap prbinu/touch2sudo
brew tap vultr/vultr-cli

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install fonts
brew install --cask font-source-code-pro
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-ubuntu-mono
brew install --cask font-meslo-lg-nerd-font
brew install --cask font-mononoki-nerd-font
brew install --cask font-montserrat
brew install --cask font-nanum-gothic-coding
brew install --cask font-open-sans
brew install --cask font-poppins
brew install --cask font-abel
brew install --cask font-dejavu
brew install --cask font-powerline-symbols
brew install --cask font-fira-code
brew install --cask font-fira-code-nerd-font
brew install --cask font-roboto
brew install --cask font-roboto-condensed
brew install --cask font-roboto-mono
brew install --cask font-fira-sans-condensed
brew install --cask font-rubik
brew install --cask font-hack-nerd-font
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask font-fira-sans
brew install --cask font-dejavu-sans-mono-nerd-font
brew install --cask font-roboto-mono-nerd-font
brew install --cask font-fira-sans
brew install --cask font-josefin-sans
brew install --cask font-material-symbols
brew install --cask font-lato

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf
brew install xz

# Install some network tools
brew install iperf3
brew install tcpdump
brew install iproute2mac
brew install speedtest-cli
brew install mtr
brew install wireshark

# Install other useful binaries.
brew install ack
#brew install exiv2
brew install git
brew install git-lfs
brew install gs
brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install jq
brew install pandoc
brew install prettier
brew install usbutils



# Install some of my commonly used tools
brew install smartmontools
brew install shfmt
brew install rclone
brew install rsync
brew install shellcheck

# Install shell stuff
brew install zsh
brew install zsh-autocomplete
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting



# Remove outdated versions from the cellar.
brew cleanup
