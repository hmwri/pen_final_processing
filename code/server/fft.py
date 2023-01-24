from pydub import AudioSegment as AS
import ffmpeg
import numpy as np

import sys
import os
import urllib.parse
import requests

file = "sz"

link = sys.argv[1]
print(link)

if link == "default":
    f = open('note.txt', 'w')

    f.write("0Z0F000F")

    f.close()
else :

    fileid = urllib.parse.urlparse(link).path.split("/")[3]

    print(fileid)

    dl_link = f"https://drive.google.com/uc?id={fileid}&export=download"

    print(dl_link)

    response = requests.get(dl_link)

    # ★ポイント3
    contentType = response.headers['Content-Type']
    contentDisposition = response.headers['Content-Disposition']
    ATTRIBUTE = 'filename='
    fileName = contentDisposition[contentDisposition.find(ATTRIBUTE) + len(ATTRIBUTE):]

    # ★ポイント4
    _ , ext = os.path.splitext(fileName)
    saveFileName = "target_audio" + ext
    with open(saveFileName, 'wb') as saveFile:
        saveFile.write(response.content)


    sound = AS.from_file(saveFileName, ext[1:])
    sound = sound.set_channels(1)

    fr = sound.frame_rate
    speed = 20
    step = int(fr / speed)

    data = np.array(sound.get_array_of_samples())

    print(data.shape)

    max_freqs = []
    t = 0
    freq = np.fft.fftfreq(step, 1.0/fr)
    freq = freq[:int(freq.shape[0]/2)]
    max_amp = np.max(np.abs(data))



    while t < min(len(data) // step, 600) :
        target_data = data[t*step: (t+1)* step]
        if np.mean(np.abs(target_data) / max_amp) < 0.0025:
            max_freqs.append(0)
            t+=1
            continue
        hann = np.hanning(len(target_data))
        target_data = target_data * hann
        spec = np.fft.fft(target_data)   #2次元配列(実部，虚部)

        spec = spec[:int(spec.shape[0]/2)]
        spec = np.abs(spec)#周波数がマイナスになるスペクトル要素の削除
           #周波数がマイナスになる周波数要素の削除
        max_spec=max(spec)    #最大音圧を取得(音圧を正規化するために使用）

        max_freqs.append(int(freq[spec.argmax()]))
        t += 1

    print(max_freqs)
    encoded = ""


    def fillNoise(i,f,window=2):
        j = i
        sames = []
        while j < len(max_freqs) and j < i + window:
            if abs(max_freqs[j] - f) < 5:
                sames.append(j)
            if max_freqs[j] == 0:
                return
            j+=1
        if len(sames) > 0:
            for idx in range(i,sames[-1] ):
                max_freqs[idx] = f

    i = 0
    while i < len(max_freqs):
        n = 1
        f = max_freqs[i]
        if i > 0 and i < len(max_freqs) -1 and \
                (abs(max_freqs[i - 1] - f)  > 10 and abs(max_freqs[i+1] - f) > 10):
            max_freqs[i] = max_freqs[i+1]
            f = max_freqs[i+1]
        while i < len(max_freqs) - 1 and abs(max_freqs[i+1] - f) < 20:
            n+=1
            i+=1
        fillNoise(i, f)
        i+=1

    i=1

    while i < len(max_freqs):
        n = 1
        fromi = i
        f = max_freqs[i]

        while i < len(max_freqs) - 1 and abs(max_freqs[i+1] - f) < 20:
            n+=1
            i+=1

        if n < 10 and (f - max_freqs[fromi - 1] > 100 and max_freqs[i+1] - f < -100):
            for j in range(fromi, i+1):
                max_freqs[j] = max_freqs[fromi - 1]


        i+=1

    i = 0
    base = 36
    while i < len(max_freqs):
        n = 1
        f = max_freqs[i]
        if i > 0 and i < len(max_freqs) -1 and \
                (abs(max_freqs[i - 1] - f)  > 10 and abs(max_freqs[i+1] - f) > 10):
            max_freqs[i] = max_freqs[i+1]
            f = max_freqs[i+1]
        while i < len(max_freqs) - 1 and abs(max_freqs[i+1] - f) < 20 and n < base**1 - 1:
            n+=1
            i+=1
        fillNoise(i, f)

        f = min(base**3-1, f)
        encoded += np.base_repr(f,base).zfill(3) + np.base_repr(n,base).zfill(1)
        i+=1






    # import matplotlib.pyplot as plt
    # x = [i for i in range(min(len(data) // step, 600))]
    # plt.plot(x, max_freqs)
    # plt.show()
    #
    #
    # import IPython
    #
    # music = np.array([])
    #
    # rate = 48000
    #
    #
    # for f in max_freqs:
    #     duration = 1 / speed
    #     t = np.linspace(0., duration, int(rate * duration))
    #     x = np.sin(2.0 * np.pi * f * t)
    #     music = np.append(music, x)
    #
    # audio = IPython.display.Audio(music, rate=rate, autoplay=True)
    # with open('test.wav', 'wb') as f:
    #     f.write(audio.data)



    f = open('note.txt', 'w')

    f.write(encoded)

    f.close()
