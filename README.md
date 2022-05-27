# Neovim Configuration

Requires neovim > 0.7.
<https://github.com/neovim/neovim/releases/latest>

```
sudo dpkg -i nvim-linux64.deb
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 10
sudo update-alternatives --config vi
```

## Clone Repo into $HOME/.config: 

```
mkdir ~/.config
git clone https://github.com/hw/nvim
cd nvim
git submodule update --init
```

## Terminal Configuration
Patch font use for terminal: 
<https://www.nerdfonts.com/font-downloads> 
or use termux styling

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts
fc-cache -fv
```

## Development Environment
Setup development environments for the various languages. You will need node.js installed for the automatic LsP Installation to work.


### node.js
```
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs
```

### python
```
apt install python3 python3-venv

# for DAP
mkdir .virtualenvs
cd .virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
debugpy/bin/python -m pip install pyright
```

### rust
Download <https://github.com/vadimcn/vscode-lldb/releases>
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
mkdir ~/.config/nvim/vscode-lldb
cd ~/.config/nvim/vscode-lldb
unzip codelldb-x86_64-linux.vsix
```

### go
<https://go.dev/dl/>
```
cd $HOME
wget https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
tar xzvf go1.18.2.linux-amd64.tar.gz
rm -f xzvf go1.18.2.linux-amd64.tar.gz
go install github.com/go-delve/delve/cmd/dlv@latest
```

### java
```
apt install default-jdk
cd $HOME/.config/nvim
# Download <https://github.com/microsoft/java-debug/releases> 
# Extract into $HOME/.config/nvim/java-debug
cd java-debug
mvn clean install
```

### c/c++
`apt install llvm`

Add the following to your $HOME/.profile
```
# add Go to path if it exists
if [ -d "$HOME/go" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi

# add Rust to path if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
    source "$HOME/.cargo/env"
fi
```

##Start nvim

```
:PackerSync
:PackerCompile
```
