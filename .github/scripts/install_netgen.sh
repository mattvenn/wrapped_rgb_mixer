set -eu
cd $HOME
git clone https://github.com/RTimothyEdwards/netgen
cd netgen
git checkout $NETGEN_VERSION
./configure
make
sudo make install
