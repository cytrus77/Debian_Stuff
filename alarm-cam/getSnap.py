import vlc

#player=vlc.MediaPlayer('rtsp://192.168.21.201:8554/output.h264')
#player.play()
#player.video_take_snapshot(0, 'cam1.png', 0, 0)

#player=vlc.MediaPlayer('rtsp://192.168.21.202:8554/output.h264')
#player.play()
#player.video_take_snapshot(0, 'cam2.png', 0, 0)

player=vlc.MediaPlayer('rtsp://192.168.21.203:554/mpeg4?username=admin&password=98E822D9E3A6E1A50D092BF1914F6F45')
player.play()
player.video_take_snapshot(0, 'cam3.png', 0, 0)
