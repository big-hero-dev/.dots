#!/bin/bash

# Đường dẫn đến video của bạn
VIDEO_PATH="$HOME/userConfig/videos/Wake the F Up Samura.mp4"

# Kiểm tra xem file video có tồn tại không
if [ ! -f "$VIDEO_PATH" ]; then
    echo "Không tìm thấy file video tại $VIDEO_PATH"
    exit 1
fi

# Đợi PipeWire khởi động và chọn đầu ra tai nghe
sleep 10  # Tăng thời gian chờ để PipeWire sẵn sàng

# Lấy tên sink của tai nghe (thay đổi theo hệ thống của bạn)
AUDIO_SINK=$(pactl list short sinks | grep -i "headphones" | awk '{print $2}')

# Đặt đầu ra âm thanh cho tai nghe (nếu tìm thấy)
if [ -n "$AUDIO_SINK" ]; then
    pactl set-default-sink "$AUDIO_SINK"
fi

# Chạy video bằng cvlc
cvlc --no-video-title-show "$VIDEO_PATH" &

exit 0
