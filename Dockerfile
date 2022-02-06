FROM emscripten/emsdk:3.1.3



ARG USER_ID
ARG GROUP_ID

RUN mkdir -p /install
RUN mkdir -p /install/lib


##################################################################
# git config
##################################################################
RUN git config --global advice.detachedHead false



##################################################################
# xtl
##################################################################
RUN mkdir -p /opt/xtl/build && \
    git clone --branch 0.7.2 --depth 1 https://github.com/xtensor-stack/xtl.git  /opt/xtl/src

RUN cd /opt/xtl/build && \
    emcmake cmake ../src/   -DCMAKE_INSTALL_PREFIX=/install

RUN cd /opt/xtl/build && \
    emmake make -j8 install


##################################################################
# nlohmannjson
##################################################################
RUN mkdir -p /opt/nlohmannjson/build && \
    git clone --branch v3.9.1 --depth 1 https://github.com/nlohmann/json.git  /opt/nlohmannjson/src

RUN cd /opt/nlohmannjson/build && \
    emcmake cmake ../src/   -DCMAKE_INSTALL_PREFIX=/install -DJSON_BuildTests=OFF

RUN cd /opt/nlohmannjson/build && \
    emmake make -j8 install


##################################################################
# xeus itself
##################################################################
# ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

RUN mkdir -p /opt/xeus &&  \
    git clone --branch 2.3.0  --depth 1   https://github.com/jupyter-xeus/xeus.git   /opt/xeus
RUN mkdir -p /xeus-build && cd /xeus-build  && ls &&\
    emcmake cmake  /opt/xeus \
        -DCMAKE_INSTALL_PREFIX=/install \
        -Dnlohmann_json_DIR=/install/lib/cmake/nlohmann_json \
        -Dxtl_DIR=/install/share/cmake/xtl \
        -DXEUS_EMSCRIPTEN_WASM_BUILD=ON
RUN cd /xeus-build && \
    emmake make -j8 install




##################################################################
# xeus-utils
##################################################################
# ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

# RUN mkdir -p /opt/xeus-utils/
RUN git clone  --branch main --depth 1 https://github.com/DerThorsten/xeus-utils.git   /opt/xeus-utils

# COPY xeus-utils /opt/xeus-utils

RUN mkdir -p /xeus-utils-build && cd /xeus-utils-build  && ls && \
    emcmake cmake  /opt/xeus-utils \
        -DXEUS_UTILS_EMSCRIPTEN_WASM_BUILD=ON \
        -DCMAKE_INSTALL_PREFIX=/install \
        -Dnlohmann_json_DIR=/install/lib/cmake/nlohmann_json \
        -Dxtl_DIR=/install/share/cmake/xtl \
        -DXEUS_UTILS_USE_SHARED_XEUS=OFF\
        -DXEUS_UTILS_BUILD_SHARED=OFF\
        -DXEUS_UTILS_BUILD_STATIC=ON\
        -DXEUS_UTILS_BUILD_XUTILS_EXECUTABLE=OFF\
        -Dxeus_DIR=/install/lib/cmake/xeus \
        -DCMAKE_CXX_FLAGS="-Oz -flto"

RUN cd /xeus-utils-build && \
    emmake make -j8

