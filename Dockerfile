FROM wtakase/geant4:10.1-centos7
MAINTAINER wtakase <wataru.takase@kek.jp>

ENV PTSIM_VERSION 101-001-003-20151217

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
