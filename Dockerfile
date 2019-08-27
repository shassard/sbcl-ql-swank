FROM ubuntu:18.04

ENV sbclver 1.5.6
ENV buildpkgs "curl bzip2 make gcc time zlib1g-dev sbcl"
ENV sbclurl http://downloads.sourceforge.net/project/sbcl/sbcl/${sbclver}/sbcl-${sbclver}-source.tar.bz2
ENV qlurl https://beta.quicklisp.org/quicklisp.lisp

WORKDIR /tmp/sbcl_build
RUN apt update && \
    apt install -y ${buildpkgs} && \
    curl -SL ${sbclurl} | \
    tar -xj && \
    curl -SOL ${qlurl} && \
    cd sbcl-${sbclver} && \
    ./make.sh --fancy && \
    ./install.sh && \
    /usr/local/bin/sbcl --load ../quicklisp.lisp \
	--eval "(quicklisp-quickstart:install)" \
	--eval "(ql:quickload :swank)" \
	--eval "(sb-ext:quit)" && \
    cd ~ && \
    rm -fr /tmp/sbcl_build && \
    dpkg -P ${buildpkgs} && \
    apt autoremove -y

EXPOSE 4005
CMD /usr/local/bin/sbcl --load ~/quicklisp/setup.lisp \
	--eval "(ql:quickload :swank)" \
	--eval "(require :swank)" \
	--eval "(setq swank::*loopback-interface* \"0.0.0.0\")" \
	--eval "(swank:create-server :port 4005 :dont-close t)"
