#!/usr/bin/env bash
#encoding=utf8

# Function to print blocks of text
function echo_block() {
    echo "----------------------------"
    echo $1
    echo "----------------------------"
}

# Deactivate virtual environment if active
function deactivate_virtualenv() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "Deactivating existing virtual environment"
        deactivate
    fi
}

# Check if Python 3.10 or newer is installed
function check_installed_python() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "Please deactivate your virtual environment before running setup.sh."
        echo "You can do this by running 'deactivate'."
        exit 2
    fi

    for v in 12 11 10
    do
        PYTHON="python3.${v}"
        which $PYTHON
        if [ $? -eq 0 ]; then
            echo "using ${PYTHON}"
            return
        fi
    done

    echo "No usable python found. Please make sure to have python3.10 or newer installed."
    exit 1
}

# Install necessary Python dependencies
function install_dependencies() {
    echo_block "Installing dependencies"
    ${PYTHON} -m pip install --upgrade pip wheel setuptools
    ${PYTHON} -m pip install --upgrade -r requirements.txt
}

# Create a virtual environment if it doesn't exist
function create_virtualenv() {
    if [ ! -d ".venv" ]; then
        echo_block "Creating virtual environment"
        ${PYTHON} -m venv .venv
    fi
    source .venv/bin/activate
}

# Install additional dependencies for plotting and other options
function install_extra_dependencies() {
    echo_block "Installing additional dependencies"

    # Install plotting dependencies (e.g., plotly)
    ${PYTHON} -m pip install --upgrade plotly

    # Install dependencies for freqai (if needed)
    if [ -f requirements-freqai.txt ]; then
        ${PYTHON} -m pip install --upgrade -r requirements-freqai.txt --use-pep517
    fi

    # Install dependencies for hyperopt (if needed)
    if [ -f requirements-hyperopt.txt ]; then
        ${PYTHON} -m pip install --upgrade -r requirements-hyperopt.txt
    fi
}

# Install TA-Lib
function install_talib() {
    if [ -f /usr/local/lib/libta_lib.a ] || [ -f /usr/local/lib/libta_lib.so ] || [ -f /usr/lib/libta_lib.so ]; then
        echo "ta-lib already installed, skipping"
        return
    fi

    echo_block "Installing TA-Lib"
    cd build_helpers && ./install_ta-lib.sh

    if [ $? -ne 0 ]; then
        echo "Quitting. Please fix the above error before continuing."
        cd ..
        exit 1
    fi;

    cd ..
}

# Install the bot
function install() {
    deactivate_virtualenv

    check_installed_python

    # Create virtual environment and activate it
    create_virtualenv

    # Install dependencies
    install_dependencies

    # Install extra dependencies like plotly and freqai if needed
    install_extra_dependencies

    # Install TA-Lib if not already installed
    install_talib

    echo_block "Installation completed. You can now run freqtrade!"
}

# Run the installation process
install


