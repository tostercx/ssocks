cmake_minimum_required(VERSION 3.10)
project(ssocks)

include_directories(. src)
AUX_SOURCE_DIRECTORY(src/libsocks AUX)
list(APPEND AUX src/configd-util.c src/auth-util.c)

add_executable(ssocks  src/ssocks.c  ${AUX})
add_executable(ssocksd src/ssocksd.c ${AUX})
add_executable(nsocks  src/nsocks.c  ${AUX})
add_executable(rcsocks src/rcsocks.c ${AUX})
add_executable(rssocks src/rssocks.c ${AUX})
