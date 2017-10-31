# if no argument is provided
if [ "$#" -lt 1 ]; then
	echo "Atleast one argument required. Terminating..."
	exit 1
fi

if [ "$1" == "-h" ] || [ "$1" == "-help" ]; then
	echo "Usage: $(basename "$0") [-h] [-help] [-install] [-build c] [-clean] [-run p]"
	
	echo ""
	echo "where:"
	echo "-h show this help text"
	echo "-help show this help text"
	echo "-install install all the required tools to build and run WaterloopDocs"
	echo "-build build WaterloopDocs (default CNAME value: docs.teamwaterloo.ca), type none to have no CNAME"
	echo "-clean cleans build directory"
	echo "-run runs the docs on local sever (default port: 4000)"
	exit 0
fi

if [ "$1" != "-h" ] && [ "$1" != "-help" ] && [ "$1" != "-install" ] && [ "$1" != "-build" ] && [ "$1" != "-clean" ] && [ "$1" != "-run" ]; then
	echo "Invalid argument value. Terminating..."
	exit 1
fi

echo "Checking for python"

# check for python
which python > /dev/null

# install python if there is such need
if  [ ! $? -eq 0 ]; then
	echo "Installing python"
	sudo apt-get install python
	
	if [ $? -eq 0 ]; then
		echo "Python installed successfully"
	fi
else
	echo "Python is already installed"
fi

# if generate argument is provided
if [ "$1" == "-build" ]; then
	cnameURL="docs.teamwaterloop.ca"
	
	if [ "$#" -eq 2 ]; then
		cnameURL= $2
	fi
	
	echo "Building WaterlooDocs"
	cd ../docs
	
	if [ ! -d "_build" ]; then
		mkdir _build
	fi	

	sphinx-build -b html . _build
	cd _build/html
	
	if [ cnameURL != "none" ]; then
		echo cnameURL >  CNAME
	fi
elif [ "$1" == "-install" ]; then
	echo "Installing tools to build WaterlooDocs"
	
	echo "Installing required libraries for Sphinx"
	pip install Sphinx
	pip install recommonmark
	pip install sphinx_rtd_theme
elif [ "$1" == "-run" ]; then
	port=4000
	if [ "$#" -eq 2 ]; then
		port = $2
	fi
	cd ../docs/_build/html
	echo "Running local server on port ${port}"
	python -m SimpleHTTPServer ${port}
elif [ "$1" == "-clean" ]; then
	echo "Cleaning all the build files"
	cd ../docs
	rm -r _build/*
	rm -r _build/.*
fi
