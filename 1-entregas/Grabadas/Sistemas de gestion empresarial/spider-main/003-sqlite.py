import requests
from bs4 import BeautifulSoup
import sqlite3

# URL of the webpage to parse
url = 'https://www.paginasamarillas.es/search/informatica/all-ma/valencia/all-is/valencia/all-ba/all-pu/all-nc/1?what=informatica&where=Valencia'

# Define headers to mimic a Chrome browser on Windows
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36'
}

# Send a GET request to the URL with the custom headers
response = requests.get(url, headers=headers)

# Check if the request was successful
if response.status_code == 200:
    # Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Find all <a> tags with class "web"
    a_tags = soup.find_all('a', class_='web')
    
    # Extract the "target" attribute from each <a> tag
    targets = [a.get('href') for a in a_tags]
    
    # Connect to SQLite database (or create it if it doesn't exist)
    conn = sqlite3.connect('targets.db')
    cursor = conn.cursor()
    
    # Create a table if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS target_attributes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            target TEXT NOT NULL
        )
    ''')
    
    # Insert each target into the database
    for target in targets:
        cursor.execute('INSERT INTO target_attributes (target) VALUES (?)', (target,))
    
    # Commit the transaction and close the connection
    conn.commit()
    conn.close()
    
    print(f"Successfully saved {len(targets)} target attributes to the database.")
else:
    print(f"Failed to retrieve the webpage. Status code: {response.status_code}")
