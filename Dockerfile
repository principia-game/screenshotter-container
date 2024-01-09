FROM alpine:3.19.0 AS base

FROM base AS build

RUN apk add --no-cache git build-base cmake ninja curl freetype-dev libpng-dev jpeg-dev mesa-dev zlib-dev sdl2 sdl2-dev sdl2_image-dev sdl2_mixer-dev sdl2_ttf-dev

WORKDIR /principia/

RUN git clone --depth 1 https://github.com/bithack/principia .

RUN cmake . -G Ninja -DSCREENSHOT_BUILD=ON
RUN ninja -j14


FROM base AS final

RUN apk add --no-cache libgcc libstdc++ mesa-dri-gallium mesa-gl xvfb freetype libpng jpeg zlib sdl2 sdl2_image sdl2_mixer sdl2_ttf

COPY --from=build /principia/principia /principia/
COPY --from=build /principia/data-pc/ /principia/data-pc/
COPY --from=build /principia/data-shared/ /principia/data-shared/


