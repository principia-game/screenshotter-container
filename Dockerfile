FROM alpine:3.19.0 AS base

# --- Build

FROM base AS build

RUN apk add --no-cache build-base cmake ninja curl freetype-dev libpng-dev jpeg-dev mesa-dev zlib-dev sdl2 sdl2-dev

WORKDIR /
RUN curl -sLf https://github.com/bithack/principia/archive/master.tar.gz | tar xzf -
RUN mv principia-master principia

WORKDIR /principia/
RUN cmake . -G Ninja -DSCREENSHOT_BUILD=ON
RUN ninja -j14

# --- Install

FROM base AS final

RUN apk add --no-cache libgcc libstdc++ mesa-dri-gallium mesa-gl xvfb freetype libpng jpeg zlib sdl2

COPY --from=build /principia/principia /principia/
COPY --from=build /principia/data-pc/ /principia/data-pc/
COPY --from=build /principia/data-shared/ /principia/data-shared/
