#!/bin/bash
#
# Tested on Ubuntu 16.04


function depend_linda {
    sudo apt-get install -y build-essential libtool automake autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils libboost-all-dev libminiupnpc-dev 
}

function depend_wallet {
	sudo add-apt-repository -y ppa:bitcoin/bitcoin
	sudo apt-get update -y
	sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
}

function depend_qt {
    sudo apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev
}

function compile_db {
	cd ~
	mkdir bitcoin/db4/

	wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
	tar -xzvf db-4.8.30.NC.tar.gz
	cd db-4.8.30.NC/build_unix/
	../dist/configure --enable-cxx
	make
	sudo make install

}

function compile_secp {
	cd ~
	git clone https://github.com/Lindacoin/Linda.git

	cd Linda/src/secp256k1/ && ./autogen.sh && ./configure && make
	sudo make install
	sudo ldconfig
}

function build_lindaqt {
    cd ~/Linda
    qmake -qt=qt5 USE_UPNP=- && make 
}


depend_linda
depend_wallet
depend_qt
compile_db
compile_sec
build_lindaqt
