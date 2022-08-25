import vlc

#player=vlc.MediaPlayer('rtsp://192.168.21.201:8554/output.h264')
#player.play()
#player.video_take_snapshot(0, 'cam1.png', 0, 0)

#player=vlc.MediaPlayer('rtsp://192.168.21.202:8554/output.h264')
#player.play()
#player.video_take_snapshot(0, 'cam2.png', 0, 0)

player=vlc.MediaPlayer('rtsp://192.168.21.201:554/ch01.264')
player.play()
player.video_take_snapshot(0, 'cam1.png', 0, 0)
