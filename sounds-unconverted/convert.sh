for i in "$@"; do
    filename=${i%.*}

    # Convert the format to a mono WAV
    avconv -y -i $i -ac 1 $filename.wav

    # Normalize the sound
    normalize-audio -a -1db $filename.wav

    # Convert the sound to OGG Vorbis and move it to the converted sounds folder
    oggenc -o ../sounds/$filename.ogg $filename.wav
done
