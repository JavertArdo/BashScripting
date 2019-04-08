#!/bin/bash
# Download m3u8 stream as mp4 file
bash -c "ffmpeg -i $1 -c copy -bsf:a aac_adtstoasc $2"
