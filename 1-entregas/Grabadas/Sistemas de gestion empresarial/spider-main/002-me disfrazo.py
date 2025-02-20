import requests
from bs4 import BeautifulSoup

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
    
    # Print the extracted targets
    for target in targets:
        print(target)
else:
    print(f"Failed to retrieve the webpage. Status code: {response.status_code}")
