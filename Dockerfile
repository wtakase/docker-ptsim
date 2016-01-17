FROM wtakase/geant4:10.1
MAINTAINER wtakase <wataru.takase@kek.jp>

ENV PTSIM_VERSION 101-001-003-20151217
ENV ROOT_VERSION 5.34.34

RUN yum install -y libX11-devel libXpm-devel libXft-devel libXext-devel
RUN mkdir -p /opt/root/{src,build} && \
    curl -o /opt/root/root_v${ROOT_VERSION}.source.tar.gz https://root.cern.ch/download/root_v${ROOT_VERSION}.source.tar.gz && \
    tar zxf /opt/root/root_v${ROOT_VERSION}.source.tar.gz -C /opt/root/src && \
    rm -f /opt/root/root_v${ROOT_VERSION}.source.tar.gz && \
    cd /opt/root/build && \
    cmake -DCMAKE_INSTALL_PREFIX=../ ../src/root && \
    cmake --build . && \
    cmake --build . --target install && \
    echo ". /opt/root/bin/thisroot.sh" > /etc/profile.d/root.sh && \
    . /opt/root/bin/thisroot.sh && \
    rm -rf /opt/root/{src,build}

RUN mkdir -p /opt/ptsim/{src,build/PTStoolkit} && \
    mkdir -p /opt/ptsim/build/PTSapps/DynamicPort && \
    mkdir -p /opt/ptsim/{PTStoolkit,PTSapps/DynamicPort} && \
    G4_VERSION=`/opt/geant4/bin/geant4-config --version` && \
    curl -o /opt/ptsim/PTSproject-${PTSIM_VERSION}.tar.gz http://wiki.kek.jp/download/attachments/5343876/PTSproject-${PTSIM_VERSION}.tar.gz && \
    tar zxf /opt/ptsim/PTSproject-${PTSIM_VERSION}.tar.gz -C /opt/ptsim/src && \
    rm -f /opt/ptsim/PTSproject-${PTSIM_VERSION}.tar.gz && \
    cd /opt/ptsim/build/PTStoolkit && \
    cmake -DCMAKE_INSTALL_PREFIX=../../PTStoolkit -DUSEIAEAPHSP=ON -DGeant4_DIR=/opt/geant4/lib64/Geant4-${G4_VERSION} ../../src/PTSproject/PTStoolkit && \
    make -j`grep -c processor /proc/cpuinfo` && make install && \
    cd /opt/ptsim/build/PTSapps/DynamicPort && \
    cmake -DUSEROOT=ON -DCMAKE_INSTALL_PREFIX=../../../PTSapps/DynamicPort -DUSEIAEAPHSP=ON -DIAEAPHSP_WRITE_USE=ON -DGeant4_DIR=/opt/geant4/lib64/Geant4-${G4_VERSION} ../../../src/PTSproject/PTSapps/DynamicPort && \
    make -j`grep -c processor /proc/cpuinfo` && make install && \
    rm -rf /opt/ptsim/{src,build}
