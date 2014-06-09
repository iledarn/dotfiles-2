DIR=$(HOME)/dotfiles
DEB_GO='https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz'

osx: symlinks ensure_brew brew python_env go_env vundle oh_my_zsh
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

deb: symlinks apt-get python_env go_env godeb vundle oh_my_zsh
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

symlinks:
	@ln -sf $(DIR)/bash/bashrc $(HOME)/.bashrc
	@ln -sf $(DIR)/zsh/zshrc $(HOME)/.zshrc
	@ln -nsf $(DIR)/vim/vim $(HOME)/.vim
	@ln -sf $(DIR)/vim/vimrc $(HOME)/.vimrc
	@ln -sf $(DIR)/git/gitconfig $(HOME)/.gitconfig
	@ln -sf $(DIR)/git/gitignore $(HOME)/.gitignore

ensure_brew:
	ruby $(DIR)/scripts/ensure_homebrew.rb

brew:
	brew bundle $(DIR)/osx/Brewfile

apt-get:
	sudo apt-get update
	sudo cat "$(DIR)/debian/packages.list" | sudo xargs apt-get -y install
	sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

python_env:
	command -v easy_install >/dev/null 2>&1 || { curl https://bootstrap.pypa.io/ez_setup.py -o - | sudo python; }
	command -v pip >/dev/null 2>&1 || sudo easy_install pip
	sudo pip install virtualenv
	sudo pip install virtualenvwrapper

go_env:
	mkdir -p $(HOME)/go

godeb:
	command -v go >/dev/null 2>&1 || { curl $(DEB_GO) -o - | sudo tar -C /usr/local -xz; }

vundle: symlinks
	git clone https://github.com/gmarik/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

oh_my_zsh:
	git clone git://github.com/robbyrussell/oh-my-zsh.git $(HOME)/.oh-my-zsh
	cp $(DIR)/zsh/*.zsh-theme $(HOME)/.oh-my-zsh/themes