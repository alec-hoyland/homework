## Slice the video files into frames

import VideoIO
import Images

cd("/home/alec/code/homework/CAS-CS-640/project")

function read_video(video_path, frame_path)
    """ saves the frames of `video_path` to `frame_path` """

    f = VideoIO.openvideo(video_path)
    img = read(f)

    counter::BigInt = 1

    while !eof(f)
        read!(f, img)
        Images.save(joinpath(frame_path, "frame_$counter.png"), img)
        counter += 1
    end
    close(f)
end

read_video(joinpath(pwd(), "data/bernie.mp4"), joinpath(pwd(), "data/frames/"))
