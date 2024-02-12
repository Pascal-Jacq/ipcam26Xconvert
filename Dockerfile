FROM debian:bullseye-slim AS builder

RUN apt update -y && apt install -y gcc cmake pkg-config libavformat-dev libavcodec-dev libavutil-dev git

WORKDIR /install

COPY CMakeLists.txt main.c ipcamvideofilefmt.h ./
RUN mkdir build && cd build \
    && cmake .. && make

FROM debian:bullseye-slim AS runner

RUN apt update -y && apt install -y --no-install-recommends ffmpeg
COPY --from=builder /install/build/ipcam264convert /bin/ipcam-convert

WORKDIR /files/

ENTRYPOINT ["/bin/ipcam-convert"]