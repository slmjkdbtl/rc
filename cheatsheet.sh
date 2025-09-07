# redirect stderr to stdout
cmd 2>&1

# redirect stdout to stderr
cmd >&2

# redirect stderr to a file
cmd 2> err.txt

# redirect both stdout and stderr to a file
cmd > out.txt 2>&1

# don't output stderr
cmd 2> /dev/null

# ffmpeg basics
ffmpeg -i input.mov output.mp4
ffmpeg -i input.mov -c copy output.mp4
ffmpeg -i input.mov -c:v copy -c:a copy output.mp4
ffmpeg -i input.mov -c:v libx264 -c:a aac output.mp4

# ffmpeg resize video
ffmpeg -i input.mp4 -vf scale=640:480 -c:a copy output.mp4
ffmpeg -i input.mp4 -vf scale=-1:720 -c:a copy output.mp4
ffmpeg -i input.mp4 -vf scale=-2:720 -c:a copy output.mp4

# ffmpeg crop video
ffmpeg -i input.mp4 -vf crop=480:640:0:0 -c:a copy output.mp4

# ffmpeg trim video
ffmpeg -i input.mp4 -ss 00:00:00.000 -t 00:05:00.000 -c copy output.mp4

# ffmpeg change video framerate
ffmpeg -i input.mp4 -vf fps=30 output.mp4

# ffmpeg change video speed
ffmpeg -i input.mp4 -vf setpts=0.5*PTS -af atempo=2 output.mp4

# ffmpeg reverse video
ffmpeg -i input.mp4 -vf reverse -af areverse output.mp4

# ffmpeg make h264 video playable on apple devices
ffmpeg -i input.mp4 -pix_fmt yuv420p output.mp4

# ffmpeg embed soft subtitle
ffmpeg -i input.mp4 -i sub.srt -c copy -c:s mov_text -metadata:s:s:0 language=eng output.mp4
ffmpeg -i input.mp4 -i eng.srt -i chi.srt -map 0 -map 1 -map 2 -c copy -c:s mov_text -metadata:s:s:0 language=eng -metadata:s:s:1 language=chi output.mp4
ffmpeg -i input_eng.mp4 -i chi.srt -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:1 language=chi output_eng_chi.mp4

# ffmpeg extract subtitle from video
ffmpeg -i input.mp4 -map 0:s:0 sub.srt
ffmpeg -i input.mp4 -map 0:s:1 sub2.srt

# ffmpeg strip video / audio / subtitle from video
ffmpeg -i input.mp4 -vn output.mp3
ffmpeg -i input.mp4 -c:v copy -an output.mp4
ffmpeg -i input.mp4 -c copy -sn output.mp4

# ffmpeg convert video to image sequence
ffmpeg -i input.mp4 output_%04d.png
ffmpeg -i input.mp4 -vf fps=1 output_%04d.png

# ffmpeg convert image sequence to video
ffmpeg -framerate 30 -i input_%04d.png -c:v libx264 -pix_fmt yuv420p output.mp4
ffmpeg -framerate 10 -i input_%04d.png output.gif

# ffmpeg convert image sequence to gif with palette
ffmpeg -framerate 10 -i input_%04d.png -vf palettegen palette.png
ffmpeg -framerate 10 -i input_%04d.png -i palette.png -lavfi "paletteuse" output.gif

# ffmpeg create still image video with audio
ffmpeg -loop 1 -i image.jpg -i audio.mp3 -c:v libx264 -tune stillimage -c:a aac -b:a 128k -shortest -pix_fmt yuv420p output.mp4

# ffmpeg resize image
ffmpeg -i input.jpg -vf scale=640:480 output.jpg
ffmpeg -i input.jpg -vf scale=640:480:flags=neighbor -q:v 2 output.jpg

# ffmpeg audio bitrate
ffmpeg -i input.flac -b:a 256k output.mp3

# ffmpeg add audio to video
ffmpeg -i input.mp4 -i input.mp3 -c copy -map 0:v:0 -map 1:a:0 output.mp4

# ffmpeg only keep audio and video
ffmpeg -i input.mp4 -map 0:v -map 0:a -c copy output.mp4

# ffmpeg remove all subtitle, data and attachments
ffmpeg -i input.mp4 -map 0 -map -0:s -map -0:d -map -0:t -c copy output.mp4

# ffmpeg remove the second audio track
ffmpeg -i input.mp4 -map 0 -map -0:a:1 -c copy output.mp4

# ffmpeg keep first video track, second audio track and all subtitles
ffmpeg -i input.mp4 -map 0:v:0 -map 0:a:1 -map 0:s output.mp4

# ffmpeg add audio to image generate video
ffmpeg -loop 1 -i input.jpg -i input.mp3 -c:v libx264 -c:a aac -b:a 256k -preset veryslow -tune stillimage -vf scale=600:600 -shortest -strict experimental -shortest output.mp4

# ffmpeg concat video
ffmpeg -i 1.mp4 -i 2.mp4 -i 3.mp4 -filter_complex "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] concat=n=3:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" out.mp4

# ffmpeg image conversion
ffmpeg -i img.png img.webp
ffmpeg -i img.png -q:v 80 img.webp

# get video width / height / duration
ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 input.mp4
ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 input.mp4
ffprobe -v error -select_streams v:0 -show_entries format=duration -of csv=p=0 input.mp4

# ffmpeg set id3tag
ffmpeg -i input.mp3
      \ -metadata title="The Will Come, Is Now"
      \ -metadata album="The Will Come, Is Now"
      \ -metadata artist="Ronnie Boykins"
      \ -metadata date="1975"
      \ -metadata track="1"
      \ -metadata disc=""
      \ -metadata TRACKTOTAL=""
      \ -metadata album_artist=""
      \ -metadata comment=""
      \ -metadata genre=""
      \ -metadata grouping=""
      \ -metadata composer=""
      \ -metadata producer=""
      \ -metadata copyright=""
      \ -metadata publisher=""
      \ -metadata encoder=""
      \ output.mp3

# transpose a song up a half step
ffmpeg -i music.mp3  -af "asetrate=44100*1.05946,aresample=44100" better_music.mp3
rubberband -p 1 music.mp3 better_music.mp3

# ffprobe get video / image dimension
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0:s=x "test.png"
ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0:s=x "test.mp4"

# caddy static file server
caddy file-server --browse --listen :2015

# curl use header
curl -H "Authorization: Bearer c35c1bea-eb03-2e10-ec33-acb230b6cb85" https://api.example.com

# curl print header
curl -i http://example.com

# curl POST request with data
curl -X POST -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" http://example.com
curl -X POST -d "@data.json" http://example.com
curl -X POST -d "param1=value1&param2=value2" http://example.com

# curl follow redirect
curl -L http://example.com

# curl don't print progress and error
curl -s http://example.com

# curl send data as multipart/form-data
curl -F "file=@img.png" https://0x0.st

# flush dns cache
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

# set names on macOS
sudo scutil --set HostName tga-macbook
sudo scutil --set LocalHostName tga-macbook
sudo scutil --set ComputerName tga-macbook

# disable gatekeeper
sudo spctl --master-disable

# clean ds store
find . -name '.DS_Store' -print -delete

# get local ip
ipconfig getifaddr en0

# get public ip
curl ifconfig.co

# list files by size
du -chs ./* .* | sort -h

# expose a local port
cloudflared tunnel --url localhost:3000

# notify
osascript -e 'display notification "msg" with title "title"'

# edit crontab
crontab -e

# generate ssh key
ssh-keygen -t rsa

# ssh auto login
ssh-add

# get character encoding
file -I file.txt

# convert character encoding
iconv -f ISO-8859-1 -t UTF-8 src.txt > dest.txt

# start a http server
python3 -m http.server
darkhttpd .

# run TempleOS with qemu
qemu-img create -f qcow2 temple 2G
qemu-system-x86_64 \
      -m 512M \
      -drive file=temple \
      -cdrom TempleOS.ISO \
      -boot order=d

# watch star wars
telnet towel.blinkenlights.nl

# rename all jpeg to jpg
f2 -f 'jpeg' -r 'jpg'

# rename all files based on id3 tags
f2 -r '{id3.artist}/{id3.album}/{id3.title}{ext}'

# append auto incrementing number
f2 -r '{%02d} {f}{ext}'

# remove white background from image
ffmpeg -i input.png -vf colorkey=white:0.05:0.0 output.png
magick input.png -transparent white output.png
magick input.png -fuzz 5% -transparent white output.png

# loop over number
for i in $(seq 1 10); do
	echo "$i"
done

# get font name
fc-scan --format "%{family}\n" font.ttf

# make font subset of characters in file
pyftsubset font.ttf --text-file=file.txt --flavor=woff2 --output-file=font.woff2

# convert epub to pdf
pandoc -f epub -t pdf --pdf-engine=tectonic "book.epub" -o "book.pdf"

# join pdf
qpdf --empty --pages ./*.pdf -- output.pdf

# extract images from pdf
pdfimages -all input.pdf img

# concat images to pdf
img2pdf ./*.jpg -o images.pdf

# make unsigned binary runnable
xattr -d com.apple.quarantine bin

# prevent macos writing metadata files on USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# screenshot config
defaults write com.apple.screencapture location -string "$HOME/Downloads"
defaults write com.apple.screencapture type -string "jpg"
defaults write com.apple.screencapture show-thumbnail -bool false
killall SystemUIServer

# change hammerspoon config dir
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

# clean all ._ files on external disk
dot_clean /Volumes/EXTDRIVE
find /Volumes/EXTDRIVE -name '._*' -print -delete

# convert simplified Chinese to Traditional
echo "我无所谓" | opencc
echo "我無所謂" | opencc -c t2s.json

# archive website
wget --convert-links --adjust-extension --page-requisites --mirror --no-parent https://landsofdream.net/

wget \
      --convert-links \
      --adjust-extension \
      --page-requisites \
      --mirror \
      --no-parent \
      -e robots=off \
      --warc-file=archive \
      --reject-regex ".*(login|track).*" \
      https://landsofdream.net/

# take screenshot of website
bunx playwright screenshot https://example.com example.png
bunx playwright screenshot --full-page https://example.com example.png

# hex dump file to embed in c
hexdump -v -e '1/1 "0x%02X, "' input.bin
xxd -i input.bin

# show a file in git history
git show HEAD~2:main.c

# stop system from disk / idle / display sleep
caffeinate -idm

# create universal binary
clang -arch arm64 -arch x86_64 main.c -o bin

# list signing identities
security find-identity -p codesigning

# list simulators
xcrun simctl list
xcrun simctl list devices

# find all files over 2G
find / -type f -size +2G 2>/dev/null
find / -type f -size +2G -exec ls -lh {} + 2>/dev/null | awk '{ print $9 ": " $5 }'

# start a systemd service and run on startup
systemctl enable --now space55.xyz

# view systemd service log
journalctl -qu space55.xyz

# set persistent hostname on Linux
sudo hostnamectl set-hostname space55.xyz

# redirect all ports 12000-12010 to port 8388
iptables -t nat -A PREROUTING -p tcp --dport 12000:12010 -j REDIRECT --to-port 8388
iptables -t nat -A PREROUTING -p udp --dport 12000:12010 -j REDIRECT --to-port 8388

# generate a v4 uuid
uuid -v 4

# start simple git server
git instaweb
git instaweb --stop

# gui guides
: << COMMENT

open an unauthorized app

  - System Settings
      > Privacy & Security
      > Security
      > Open Anyway

manage quick action menu items

  - System Settings
      > Privacy & Security
      > Extensions
      > Finder

if software like mpv can't display Chinese font

  - Font Book.app
      > All Fonts
      > Inactive
      > Download the font (e.g. PingFang SC)

logic pro enable undo for plugins and mixer

  - Logic Pro.app
      > Edit
      > Undo History
      > Check "Mixer" and "Plug-In" in "Include Parameter Changes From"

COMMENT
