cmake_minimum_required(VERSION 3.10)
project(ssocks)

include_directories(. src)
AUX_SOURCE_DIRECTORY(src/libsocks AUX)
list(APPEND AUX src/configd-util.c src/auth-util.c)

if (WIN32)
  list(APPEND AUX src/win_getopt.c)
  link_libraries(ws2_32)
endif(WIN32)

add_executable(ssocks  src/ssocks.c  ${AUX})
add_executable(ssocksd src/ssocksd.c ${AUX})
add_executable(nsocks  src/nsocks.c  ${AUX})
add_executable(rcsocks src/rcsocks.c ${AUX})
add_executable(rssocks src/rssocks.c ${AUX})
