import cv2
import mediapipe as mp
import pyautogui

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_face_mesh = mp.solutions.face_mesh

anchura = 1920
altura = 1080

centropantallax = round(1920/2)
centropantallay = round(1080/2)

centrovideox = round(640/2)
centrovideoy = round(480/2)




# For webcam input:
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

        # To improve performance, mark the image as not writeable
        image.flags.writeable = False
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = face_mesh.process(image)

        # Draw the face mesh annotations on the image.
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        
        if results.multi_face_landmarks:
            for face_landmarks in results.multi_face_landmarks:
                # Extracting specific mesh point coordinates for the nose
                nose_landmark = face_landmarks.landmark[1]  # Index 1 is often the tip of the nose
                h, w, _ = image.shape  # Height and width of the image
                
                # Convert the normalized landmark coordinates to pixel values
                x = int(nose_landmark.x * w)
                y = int(nose_landmark.y * h)
                
                #print(f'Nose landmark coordinates: (x: {x}, y: {y})')
                pyautogui.moveTo(
                    XXX
                    )

                # Optionally, draw a circle at the nose landmark
                cv2.circle(image, (x, y), 5, (0, 255, 0), -1)
                
                # Draw the full face mesh
                mp_drawing.draw_landmarks(
                    image=image,
                    landmark_list=face_landmarks,
                    connections=mp_face_mesh.FACEMESH_TESSELATION,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_drawing_styles
                    .get_default_face_mesh_tesselation_style())
                
        # Flip the image horizontally for a selfie-view display
        cv2.imshow('MediaPipe Face Mesh', cv2.flip(image, 1))
        if cv2.waitKey(5) & 0xFF == 27:
            break
            
cap.release()
