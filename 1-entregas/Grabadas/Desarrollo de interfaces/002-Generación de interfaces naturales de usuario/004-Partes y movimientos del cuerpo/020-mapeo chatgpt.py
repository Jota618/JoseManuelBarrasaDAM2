import cv2
import mediapipe as mp
import pyautogui

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_face_mesh = mp.solutions.face_mesh

# Resolución de la pantalla
anchura = 1920
altura = 1080

# Centro de la pantalla
centropantallax = round(anchura / 2)
centropantallay = round(altura / 2)

# Resolución del video de la webcam
resolucion_video_x = 640
resolucion_video_y = 480

# Centro del video de la webcam
centrovideox = round(resolucion_video_x / 2)
centrovideoy = round(resolucion_video_y / 2)

# Sensibilidad del movimiento
sensibilidad = 12.5  # Aumenta o disminuye según la sensibilidad que prefieras

# Iniciar captura de video
cap = cv2.VideoCapture(0)
with mp_face_mesh.FaceMesh(
    max_num_faces=1,
    refine_landmarks=True,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5) as face_mesh:
    
    while cap.isOpened():
        success, image = cap.read()
        if not success:
            print("Ignoring empty camera frame.")
            continue

        # Preparar la imagen para MediaPipe
        image.flags.writeable = False
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = face_mesh.process(image)

        # Dibujar anotaciones de la malla facial
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        
        if results.multi_face_landmarks:
            for face_landmarks in results.multi_face_landmarks:
                # Coordenadas del punto de referencia de la nariz
                nose_landmark = face_landmarks.landmark[1]  # Índice 1 es la punta de la nariz
                h, w, _ = image.shape  # Altura y anchura de la imagen
                
                # Convertir coordenadas normalizadas a píxeles
                x_nose = int(nose_landmark.x * w)
                y_nose = int(nose_landmark.y * h)
                
                # Calcular desplazamiento de la nariz respecto al centro del video
                desplazamiento_x = x_nose - centrovideox
                desplazamiento_y = y_nose - centrovideoy
                
                # Escalar el movimiento según la resolución de la pantalla y la sensibilidad
                movimiento_x = centropantallax + (desplazamiento_x * sensibilidad)
                movimiento_y = centropantallay + (desplazamiento_y * sensibilidad)

                # Limitar el movimiento del ratón dentro de los límites de la pantalla
                movimiento_x = max(0, min(anchura, movimiento_x))
                movimiento_y = max(0, min(altura, movimiento_y))

                # Mover el cursor del ratón
                pyautogui.moveTo(1920-movimiento_x, movimiento_y)

                # Dibujar un círculo en la nariz para referencia visual
                cv2.circle(image, (x_nose, y_nose), 5, (0, 255, 0), -1)
                
                # Dibujar la malla facial completa
                mp_drawing.draw_landmarks(
                    image=image,
                    landmark_list=face_landmarks,
                    connections=mp_face_mesh.FACEMESH_TESSELATION,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_drawing_styles
                    .get_default_face_mesh_tesselation_style())
                
        # Mostrar la imagen con la malla facial en modo selfie
        cv2.imshow('MediaPipe Face Mesh', cv2.flip(image, 1))
        if cv2.waitKey(5) & 0xFF == 27:  # Presionar "Esc" para salir
            break
            
cap.release()
cv2.destroyAllWindows()
