FROM debian:stretch
LABEL version="1.5.0" maintainer="frandelhoyo@gmail.com" author="Howard Butler <howard@hobu.co>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      cmake \
      ninja-build \
      g++ \
      git \
      libcurl4-gnutls-dev \
      libcurl3-gnutls \
      libhpdf-dev \
      libhpdf-2.2.1 \
      libgdal-dev \
      libgdal20 \
      libgeotiff-dev \
      libjsoncpp-dev \
      libjsoncpp1 \
      libgeotiff2 \
      libproj12 \
      liblzma5 \
      libgomp1 \
      libgeos-c1v5 \
      libcurl3 \
      libarmadillo7 \
      libwebp6 \
      libeigen3-dev && \
    # Install laszip library \
    git clone https://github.com/LASzip/LASzip /tmp/laszip && \
    cd /tmp/laszip && \
    git checkout e7065cbc5bdbbe0c6e50c9d93d1cd346e9be6778 && \
    mkdir /tmp/laszip/build && cd /tmp/laszip/build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE="Release" .. && \
    ninja install && \
    # Install laz-perf library \
    git clone https://github.com/hobu/laz-perf /tmp/laz-perf && \
    mkdir /tmp/laz-perf/build && cd /tmp/laz-perf/build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE="Release" .. && \
    ninja install && \
    # Install NITRO library \
    git clone https://github.com/hobu/nitro /tmp/nitro && \
    mkdir /tmp/nitro/build && cd /tmp/nitro/build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE="Release" .. && \
    ninja install && \
    # Install HEXER library \
    git clone https://github.com/hobu/hexer /tmp/hexer && \
    mkdir /tmp/hexer/build && cd /tmp/hexer/build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE="Release" .. && \
    ninja install && \
    # Install CPD library \
    git clone --depth 1 --branch v0.4.6 https://github.com/gadomski/fgt /tmp/fgt && \
    mkdir /tmp/fgt/build && cd /tmp/fgt/build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE="Release" -DBUILD_SHARED_LIBS=ON .. && \
    ninja install && \
    # Install Fass Gaussian Transform library \
    git clone --depth 1 --branch v0.4.6 https://github.com/gadomski/fgt /tmp/fgt && \
    mkdir /tmp/fgt/build && cd /tmp/fgt/build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE="Release" -DBUILD_SHARED_LIBS=ON .. && \
    ninja install && \
    # Install Coherent Point Drift segmentation library \
    git clone --depth 1 --branch v0.5.1 https://github.com/gadomski/cpd /tmp/cpd && \
    mkdir /tmp/cpd/build && cd /tmp/cpd/build && \
    cmake -GNinja \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE="Release" \
      -DBUILD_SHARED_LIBS=ON \
      -DWITH_FGT=ON \
      -DWITH_STRICT_WARNINGS=OFF \
      -DWITH_DOCS=OFF \
      -DBUILD_SHARED_LIBS=ON \
      .. && \
    ninja install && \
    # Install PDAL library \
    git clone --depth=1 -b master https://github.com/PDAL/PDAL /tmp/pdal && \
    mkdir /tmp/pdal/build && cd /tmp/pdal/build && \
    cmake -GNinja \
      -DBUILD_PLUGIN_CPD=ON \
      -DBUILD_PLUGIN_MBIO=ON \
      -DBUILD_PLUGIN_GREYHOUND=ON \
      -DBUILD_PLUGIN_HEXBIN=ON \
      -DBUILD_PLUGIN_ICEBRIDGE=ON \
      -DBUILD_PLUGIN_MRSID=ON \
      -DBUILD_PLUGIN_NITF=ON \
      -DENABLE_CTEST=OFF \
      -DWITH_APPS=ON \
      -DWITH_LAZPERF=ON \
      -DWITH_LASZIP=ON \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release \
      .. && \
    ninja install && \
    # Install PRC PDAL plugin \
    git clone https://github.com/PDAL/PRC /tmp/prc && \
    mkdir /tmp/prc/build && cd /tmp/prc/build && \
    cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DPDAL_DIR=/usr/lib/pdal/cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    ninja install && \
    # Remove dev dependencies and source code \
    apt-get purge -y \
      cmake \
      ninja-build \
      g++ \
      git \
      libgdal-dev \
      libhpdf-dev \
      libjsoncpp-dev \
      libcurl4-gnutls-dev \
      libeigen3-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

CMD ["/usr/bin/pdal"]
