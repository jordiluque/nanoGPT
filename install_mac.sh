#!/bin/bash
## This script install necessary libs and environment for running the code
## in a M1/2 MacBook machine
#
# Author: Jordi Luque 05/15/2023
# Status: Not tested

## Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

## Install pyenv and virtualenv
brew install pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile

alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
echo 'alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'' >> ~/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile

brew install pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

## Restart shell
exec "$SHELL"

## Creating pyenv environment
pyenv install 3.10.11
pyenv virtualenv 3.10.11 nanoGPT
pyenv activate nanoGPT

## Cloninig codecarbone
pip install codecarbon
! codecarbon init
echo "log_level = DEBUG
save_to_api = True" >> .codecarbon.config

## Cloning nanoGPT repo
git clone https://github.com/jordiluque/nanoGPT.git
cd nanoGPT
pip install -U pip
pip install -r requirements.txt

## Running code, training shakespeare char with CO2 emissions tracking
python data/shakespeare_char/prepare.py 
python train.py config/train_shakespeare_char.py --device='mps' --compile=False --max_iters=100 --eval_iters=20 --eval_interval=50 --out_dir='out-shakespeare-char-100' --batch_size=32
