#!/bin/bash

clr() {
	killall ssocks ssocksd nsocks rcsocks rssocks nc 2>/dev/null
}

hl() {
	echo -e "\033[0;33m$*\033[0m"
}

sdir="${0%/*}"
pushd "${sdir}/build"
clr

hl "test ssocksd (nc -> ssd -> curl)"
tstr=$(tr </dev/urandom -dc a-z | head -c6)
echo -ne "HTTP/1.0 200 OK\r\nContent-Length: 6\r\n\r\n$tstr" | nc -l 8080 >/dev/null &
./ssocksd -p 8081 -d
ret=$(curl -s -x socks5://127.0.0.1:8081 127.0.0.1:8080)

if [ "$ret" != "$tstr" ]; then
	hl "Expected '$tstr', got '$ret'"
	exit 1
else hl "ok"; fi

hl "test ssocks (nc -> ssd -> ss -> curl)"
tstr=$(tr </dev/urandom -dc a-z | head -c6)
echo -ne "HTTP/1.0 200 OK\r\nContent-Length: 6\r\n\r\n$tstr" | nc -l 8080 >/dev/null &
./ssocks -s 127.0.0.1:8081 -l 8082 -b
ret=$(curl -s -x socks5://127.0.0.1:8082 127.0.0.1:8080)

if [ "$ret" != "$tstr" ]; then
	hl "Expected '$tstr', got '$ret'"
	exit 1
else hl "ok"; fi

hl "test nsocks (nc -> ssd -> ns)"
tstr=$(tr </dev/urandom -dc a-z | head -c6)
echo -ne "HTTP/1.0 200 OK\r\nContent-Length: 6\r\n\r\n$tstr" | nc -q 5 -l 8080 >/dev/null &
ret=$(./nsocks -s 127.0.0.1:8081 127.0.0.1 8080 | tail -n 1)

if [ "$ret" != "$tstr" ]; then
	hl "Expected '$tstr', got '$ret'"
	exit 1
else hl "ok"; fi

killall nc

hl "test r[sc]socks (nc -> rss -> rcs -> curl)"
tstr=$(tr </dev/urandom -dc a-z | head -c6)
echo -ne "HTTP/1.0 200 OK\r\nContent-Length: 6\r\n\r\n$tstr" | nc -l 8080 >/dev/null &
./rcsocks -p 8083 -l 8084 -b
./rssocks -s 127.0.0.1:8083 -b
ret=$(curl -s -x socks5://127.0.0.1:8084 127.0.0.1:8080)

if [ "$ret" != "$tstr" ]; then
	hl "Expected '$tstr', got '$ret'"
	exit 1
else hl "ok"; fi

clr
popd
