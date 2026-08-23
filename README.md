# RETH
# flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
# git clone https://github.com/flutter/flutter.git -b stable ~/flutter && echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc

Install the Flutter environment

We're going to put Flutter in:

/workspaces/RETH/.flutter

That is inside your repository workspace, rather than /opt or /usr/local.

1. Install Flutter's Linux dependencies

Run:

# sudo apt-get update

Then:

# sudo apt-get install -y \
  curl \
  git \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa \
  clang \
  cmake \
  ninja-build \
  pkg-config \
  libgtk-3-dev \
  liblzma-dev

Let that finish.

2. Download Flutter stable

Then run:

# cd /workspaces/RETH

Then:

# git clone --depth 1 --branch stable https://github.com/flutter/flutter.git .flutter

This will create:

/workspaces/RETH/.flutter
3. Add Flutter to your PATH

Run:

# echo 'export PATH="/workspaces/RETH/.flutter/bin:$PATH"' >> ~/.bashrc

Then activate it immediately:

export PATH="/workspaces/RETH/.flutter/bin:$PATH"

4. Enable Flutter Web

Run:

flutter config --enable-web

Then:

flutter precache --web

This downloads the web-specific Flutter artifacts.

It can take a little while.

Start Flutter's web server

Run:

# flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0