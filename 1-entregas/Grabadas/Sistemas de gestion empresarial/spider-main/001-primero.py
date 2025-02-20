import requests
from bs4 import BeautifulSoup

# URL of the webpage to parse
url = 'https://www.paginasamarillas.es/search/informatica/all-ma/valencia/all-is/valencia/all-ba/all-pu/all-nc/1?what=informatica&where=Valencia'

# Send a GET request to the URL
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Find all <a> tags with class "web"
    a_tags = soup.find_all('a', class_='web')
    
    # Extract the "target" attribute from each <a> tag
    targets = [a.get('target') for a in a_tags]
    
    # Print the extracted targets
    for target in targets:
        print(target)
else:
    print(f"Failed to retrieve the webpage. Status code: {response.status_code}")
