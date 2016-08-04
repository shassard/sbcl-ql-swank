SBCL (from source) + Quicklisp + Swank Dockerfile
=================================================

This repo contains a Dockerfile that will build SBCL from a source tarball, download and install the latest Quicklisp, and preload Swank in the environment so that you can easily connect to the container as a remote repl from Emacs.