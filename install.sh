#!/bin/bash
sudo apt install subfinder
sudo apt install httprobe
# Create the main folder
cd /$USER/Multiple

# Create subfolders
mkdir tools

# Install Sublist3r
echo "Installing Sublist3r..."
cd /$USER/Multiple/tools
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
sudo pip install -r requirements.txt
sudo pip install requests
sudo pip install dnspython
sudo pip install argparse

# Install Eyewitness
echo "Installing Eyewitness..."
cd /$USER/Multiple/tools
git clone https://github.com/RedSiege/EyeWitness.git
cd EyeWitness/Python/setup
./setup.sh
cd ~
