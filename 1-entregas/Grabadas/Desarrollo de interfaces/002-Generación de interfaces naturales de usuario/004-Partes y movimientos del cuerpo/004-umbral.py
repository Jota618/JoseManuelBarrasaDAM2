import cv2                                                                                      # Esta es la importación de la libreria OpenCV para tratamiento de imagen
import mediapipe as mp                                                                          # Mediapipe se apoya en OpenCV para reconocimiento facial, manos, cuerpo
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_hands = mp.solutions.hands                                                                   # Arranco la solución de manos

# For static images:
IMAGE_FILES = []
with mp_hands.Hands(                                                                            
    static_image_mode=True,                                                                     
    max_num_hands=1,                                                                           
    min_detection_confidence=0.5) as hands: # Maximo 2 manos
  for idx, file in enumerate(IMAGE_FILES):                                                      # Para cada una de las imagenes
    image = cv2.flip(cv2.imread(file), 1)                                                       # Volteo la imagen para efecto espejo
    results = hands.process(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))                             # Convierto la imagen a RGB

    print('Handedness:', results.multi_handedness)                                              # Imprimo la mano con la que estoy trabajando
    if not results.multi_hand_landmarks:
      continue
    image_height, image_width, _ = image.shape
    annotated_image = image.copy()
    for hand_landmarks in results.multi_hand_landmarks:
      print('hand_landmarks:', hand_landmarks)
      print(
          f'Index finger tip coordinates: (',
          f'{hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP].x * image_width}, '
          f'{hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP].y * image_height})'
      )
      mp_drawing.draw_landmarks(
          annotated_image,
          hand_landmarks,
          mp_hands.HAND_CONNECTIONS,
          mp_drawing_styles.get_default_hand_landmarks_style(),
          mp_drawing_styles.get_default_hand_connections_style())
    cv2.imwrite(
        '/tmp/annotated_image' + str(idx) + '.png', cv2.flip(annotated_image, 1))
    # Draw hand world landmarks.
    if not results.multi_hand_world_landmarks:
      continue
    for hand_world_landmarks in results.multi_hand_world_landmarks:
      mp_drawing.plot_landmarks(
        hand_world_landmarks, mp_hands.HAND_CONNECTIONS, azimuth=5)

# For webcam input:
cap = cv2.VideoCapture(0)
with mp_hands.Hands(
    model_complexity=0,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5) as hands:
  while cap.isOpened():
    success, image = cap.read()
    if not success:
      print("Ignoring empty camera frame.")
      # If loading a video, use 'break' instead of 'continue'.
      continue

    # To improve performance, optionally mark the image as not writeable to
    # pass by reference.
    image.flags.writeable = False
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    results = hands.process(image)

    # Draw the hand annotations on the image.
    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    if results.multi_hand_landmarks:
      for hand_landmarks in results.multi_hand_landmarks:
        mp_drawing.draw_landmarks(
            image,
            hand_landmarks,
            mp_hands.HAND_CONNECTIONS,
            mp_drawing_styles.get_default_hand_landmarks_style(),
            mp_drawing_styles.get_default_hand_connections_style())

        umbral = 5
        punto1 = (0,0,0)
        punto2 = (0,0,0)
        
        for idx, landmark in enumerate(hand_landmarks.landmark):
            if idx == 4:
                punto1 = (landmark.x,landmark.y,landmark.z)
            elif idx == 8:
                punto2 = (landmark.x,landmark.y,landmark.z)
        print(punto1,punto2)
        if abs(punto1[0] - punto2[0]) > umbral and abs(punto1[1] - punto2[1]) > umbral and abs(punto1[2] - punto2[2]) > umbral:
            print("estan cerca!!!!!")


        
    # Flip the image horizontally for a selfie-view display.
    cv2.imshow('MediaPipe Hands', cv2.flip(image, 1))
    if cv2.waitKey(5) & 0xFF == 27:
      break
cap.release()






