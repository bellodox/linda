#!/bin/bash
#
# Tested on Ubuntu 16.04 (Vultr)

function depend_linda {
    sudo apt-get install -y build-essential libtool automake autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils libboost-all-dev
}

function depend_wallet {
	sudo add-apt-repository -y ppa:bitcoin/bitcoin
	sudo apt-get update -y
	sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
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

function enable_swap {
	sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=1000 
	sudo mkswap /var/swap.img 
	sudo chmod 0600 /var/swap.img 
	sudo chown root:root /var/swap.img
	sudo swapon /var/swap.img

	#echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
}

function compile_linda {
	cd ~/Linda
    qmake -qt=qt5 USE_UPNP=- && make
    strip Lindad
}

function move_bins {
    cd ~/Linda/src
    cp Lindad /usr/local/bin
}


function service_linda {
    cp linda.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl start linda.service
    sudo systemctl enable linda.service
}


depend_wallet
compile_db
compile_secp
enable_swap
compile_linda
move_bins


