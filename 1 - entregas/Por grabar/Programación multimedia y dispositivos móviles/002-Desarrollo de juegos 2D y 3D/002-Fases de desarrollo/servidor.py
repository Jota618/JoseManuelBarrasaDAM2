from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
# Initialize game state
game_state = {
    "mensaje": [],  # To store the array with the piece positions
    "last_updated_by": "",  # To track which player last updated the state
}

# Route to update the game state (called by either player 1 or player 2)
@app.route('/update_board', methods=['POST'])
def update_board():
    data = request.get_json()
    
    mensaje = data.get('mensaje')  # Get the updated "mensaje" array
    player = data.get('player')     # Get the player identifier (p1 or p2)
    
    # Update game state
    game_state['mensaje'] = mensaje
    game_state['last_updated_by'] = player
    
    return jsonify({"status": "success", "message": "Board updated by " + player})

# Route to get the current game state (used by both players to sync)
@app.route('/get_board', methods=['GET'])
def get_board():
    return jsonify(game_state)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

