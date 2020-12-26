FROM archlinux:base-devel
MAINTAINER Scarjit <scarjit@aol.com>
RUN pacman -Sy
RUN pacman -S perl gcc git make automake autoconf libtool libnghttp2 libpsl librtmp0 brotli python perl-text-glob clang --noconfirm --needed
RUN mkdir install_dir
WORKDIR /install_dir
RUN pwd
RUN curl -O https://www.openssl.org/source/openssl-1.1.0f.tar.gz
RUN tar xf openssl-1.1.0f.tar.gz
RUN rm openssl-1.1.0f.tar.gz
RUN ls -la
WORKDIR /install_dir/openssl-1.1.0f
RUN ls -la
ENV PATH="/usr/bin/core_perl:$PATH"
RUN sed -i "s#'File::Glob' => qw/glob/;#'File::Glob' => qw/bsd_glob/;#g" test/recipes/90-test_fuzz.t
RUN sed -i "s#'File::Glob' => qw/glob/;#'File::Glob' => qw/bsd_glob/;#g" test/recipes/80-test_ssl_new.t
RUN sed -i "s#'File::Glob' => qw/glob/;#'File::Glob' => qw/bsd_glob/;#g" test/recipes/40-test_rehash.t
RUN sed -i "s#'File::Glob' => qw/glob/;#'File::Glob' => qw/bsd_glob/;#g" test/build.info
RUN sed -i "s#'File::Glob' => qw/glob/;#'File::Glob' => qw/bsd_glob/;#g" test/run_tests.pl
RUN sed -i "s#'File::Glob' => qw/glob/;#'File::Glob' => qw/bsd_glob/;#g" util/process_docs.pl
RUN sed -i "s#'File::Glob' => qw/glob/;#'File::Glob' => qw/bsd_glob/;#g" Configure
RUN chmod +x Configure
RUN perl Configure linux-x86_64 -fPIC
RUN make -j$(nproc)
RUN make install
WORKDIR /install_dir
RUN rm -r openssl-1.1.0f
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"
RUN rustup toolchain install nightly
RUN rustup default nightly
RUN rustup component add clippy-preview

