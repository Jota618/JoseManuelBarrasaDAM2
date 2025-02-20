import cv2
import mediapipe as mp
import threading
import time
from gtts import gTTS
import pygame
import speech_recognition as sr
from openai import OpenAI
import numpy as np
from scipy.io import wavfile
import os
from pydub import AudioSegment

mp_face_detection = mp.solutions.face_detection
mp_drawing = mp.solutions.drawing_utils

r = sr.Recognizer()

client = OpenAI()

haypersona = False
temphaypersona = False
stop_thread = False

def mi_openai(entrada):
    response = client.chat.completions.create(
        model="gpt-3.5-turbo-0125",
        messages=[
            {
                "role": "user",
                "content": entrada
            }
        ],
        temperature=0.7,
        max_tokens=1024,
        top_p=1
    )
    message_content = response.choices[0].message.content
    return message_content

def generate_waveform(audio_data, sample_rate):
    times = np.arange(len(audio_data)) / float(sample_rate)
    amplitude = audio_data / np.max(np.abs(audio_data), axis=0)
    return times, amplitude

def plot_waveform_radial(amplitude, frame_size=(500, 500)):
    frame = np.ones((frame_size[0], frame_size[1], 3), dtype=np.uint8) * 255
    center = (frame_size[0] // 2, frame_size[1] // 2)
    max_radius = min(center) - 10
    num_points = len(amplitude)
    angle_step = 2 * np.pi / num_points

    for i in range(num_points):
        angle = i * angle_step
        radius = max_radius * (1 + amplitude[i]) / 2
        end_point = (int(center[0] + radius * np.cos(angle)), int(center[1] + radius * np.sin(angle)))
        cv2.line(frame, center, end_point, (0, 0, 0), 1)
    
    return frame

def text_to_speech(text, lang='es'):
    epoch = time.time()
    mp3_file = "audiotemp/"+str(epoch)+".mp3"
    wav_file = "audiotemp/"+str(epoch)+".wav"
    tts = gTTS(text=text, lang=lang)
    tts.save(mp3_file)

    # Convert MP3 to WAV
    sound = AudioSegment.from_mp3(mp3_file)
    sound.export(wav_file, format="wav")

    pygame.mixer.init()
    pygame.mixer.music.load(mp3_file)
    pygame.mixer.music.play()

    sample_rate, audio_data = wavfile.read(wav_file)
    duration = len(audio_data) / sample_rate
    _, amplitude = generate_waveform(audio_data, sample_rate)

    while pygame.mixer.music.get_busy():
        frame = plot_waveform_radial(amplitude)
        cv2.imshow('Waveform', frame)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            break

    pygame.mixer.music.stop()
    cv2.destroyWindow('Waveform')
    #os.remove(mp3_file)
    #os.remove(wav_file)

def capture_video():
    global haypersona
    video_capture = cv2.VideoCapture(0)
    with mp_face_detection.FaceDetection(model_selection=1, min_detection_confidence=0.5) as face_detection:
        while not stop_thread:
            ret, frame = video_capture.read()
            if not ret:
                continue
            rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            results = face_detection.process(rgb_frame)
            if results.detections:
                for detection in results.detections:
                    mp_drawing.draw_detection(frame, detection)
            cv2.imshow('Video', frame)
            if results.detections:
                haypersona = True
            else:
                haypersona = False
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
    video_capture.release()
    cv2.destroyAllWindows()

stop_thread = False
video_thread = threading.Thread(target=capture_video)
video_thread.start()

print("The video capture is running in a separate thread.")

try:
    while not stop_thread:
        if temphaypersona != haypersona:
            if haypersona == True:
                text_to_speech("Hola bienvenido!", lang='es')
                with sr.Microphone() as source:
                    print("Listening...")
                    r.adjust_for_ambient_noise(source)
                    audio_data = r.listen(source, timeout=5)
                    print("Recognizing...")
                    try:
                        text = r.recognize_google(audio_data, language='es-ES')
                        respuesta = mi_openai(text)
                        text_to_speech(respuesta, lang='es')
                    except sr.UnknownValueError:
                        print("e1")
                    except sr.RequestError:
                        print("e2")
            else:
                text_to_speech("Oh vaya te has ido", lang='es')
            temphaypersona = haypersona
        time.sleep(1)
except KeyboardInterrupt:
    stop_thread = True
    video_thread.join()
    print("Video capture stopped.")
